import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_collar_app/core/constants/colors.dart';
import 'package:smart_collar_app/features/chat/domain/chat_advisor.dart';
import 'package:smart_collar_app/features/dashboard/data/models/sensor_reading.dart';
import 'package:smart_collar_app/features/dashboard/providers/live_readings_provider.dart';
import 'package:smart_collar_app/features/dashboard/providers/websocket_provider.dart';
import 'package:smart_collar_app/features/herd/providers/herd_provider.dart';
import 'package:smart_collar_app/features/onboarding/data/models/collar.dart';
import 'package:smart_collar_app/shared/widgets/error_view.dart';
import 'package:smart_collar_app/shared/widgets/loading_shimmer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _advisor = ChatAdvisor();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      text:
          'Hello. Select General or a collar, then ask about health, behavior, or PPR risk.',
      fromUser: false,
    ),
  ];
  String? _selectedCollarId;
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(websocketStreamProvider);
    ref.watch(farmLatestReadingsProvider);
    final collarsValue = ref.watch(farmCollarsProvider);
    final readingsState = ref.watch(liveReadingsProvider);

    return collarsValue.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: LoadingShimmer(height: 220),
      ),
      error: (error, _) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(farmCollarsProvider),
          ),
        ],
      ),
      data: (collars) => _ChatBody(
        controller: _controller,
        messages: _messages,
        isTyping: _isTyping,
        examples: ChatAdvisor.examples,
        collars: collars,
        selectedCollarId: _selectedCollarId,
        readingsState: readingsState,
        onBack: () => context.go('/dashboard'),
        onSelectCollar: (value) => setState(() => _selectedCollarId = value),
        onSend: (text) => _send(text, readingsState),
      ),
    );
  }

  Future<void> _send(String value, ReadingsState readingsState) async {
    final text = value.trim();
    if (text.isEmpty || _isTyping) return;
    final farmReadings = readingsState.latestByCollar.values.toList();
    final selectedReading = _selectedCollarId == null
        ? null
        : readingsState.latestByCollar[_selectedCollarId];
    final reply = _advisor.reply(
      message: text,
      readings: farmReadings,
      selectedReading: selectedReading,
    );
    setState(() {
      _messages.add(_ChatMessage(text: text, fromUser: true));
      _isTyping = true;
    });
    _controller.clear();

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(text: reply, fromUser: false));
    });
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.controller,
    required this.messages,
    required this.isTyping,
    required this.examples,
    required this.collars,
    required this.selectedCollarId,
    required this.readingsState,
    required this.onBack,
    required this.onSelectCollar,
    required this.onSend,
  });

  final TextEditingController controller;
  final List<_ChatMessage> messages;
  final bool isTyping;
  final List<String> examples;
  final List<Collar> collars;
  final String? selectedCollarId;
  final ReadingsState readingsState;
  final VoidCallback onBack;
  final ValueChanged<String?> onSelectCollar;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    final selectedReading = selectedCollarId == null
        ? null
        : readingsState.latestByCollar[selectedCollarId];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health assistant',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      selectedCollarId == null
                          ? 'General farm chat'
                          : 'Specific collar chat',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: kTextSecond),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _ScopeSelector(
            collars: collars,
            selectedCollarId: selectedCollarId,
            onChanged: onSelectCollar,
          ),
        ),
        if (selectedCollarId != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SelectedReadingSummary(reading: selectedReading),
          ),
        ],
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final example = examples[index];
              return ActionChip(
                label: Text(example),
                onPressed: isTyping ? null : () => onSend(example),
                backgroundColor: kBgCard,
                side: const BorderSide(color: kAccentSoft),
                labelStyle: const TextStyle(color: kTextSecond),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemCount: examples.length,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: messages.length + (isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length) return const _TypingBubble();
              return _MessageBubble(message: messages[index]);
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ask about PPR, pulse, behavior...',
                    ),
                    onSubmitted: onSend,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: isTyping ? null : () => onSend(controller.text),
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScopeSelector extends StatelessWidget {
  const _ScopeSelector({
    required this.collars,
    required this.selectedCollarId,
    required this.onChanged,
  });

  final List<Collar> collars;
  final String? selectedCollarId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('General'),
          selected: selectedCollarId == null,
          onSelected: (_) => onChanged(null),
          selectedColor: kAccentPrimary,
          backgroundColor: kBgCard,
          side: const BorderSide(color: kAccentSoft),
          labelStyle: TextStyle(
            color: selectedCollarId == null ? kTextPrimary : kTextSecond,
          ),
        ),
        ...collars.map(
          (collar) => ChoiceChip(
            label: Text(collar.deviceId),
            selected: selectedCollarId == collar.id,
            onSelected: (_) => onChanged(collar.id),
            selectedColor: kAccentPrimary,
            backgroundColor: kBgCard,
            side: const BorderSide(color: kAccentSoft),
            labelStyle: TextStyle(
              color: selectedCollarId == collar.id ? kTextPrimary : kTextSecond,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedReadingSummary extends StatelessWidget {
  const _SelectedReadingSummary({required this.reading});

  final SensorReading? reading;

  @override
  Widget build(BuildContext context) {
    final current = reading;
    final text = current == null
        ? 'No live reading yet for this collar.'
        : '${current.heartRateBpm} bpm | ${current.tempC.toStringAsFixed(1)} C | risk ${current.pprRiskScore}%';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAccentSoft),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: kTextSecond, height: 1.35),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment = message.fromUser
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final color = message.fromUser ? kAccentPrimary : kBgCard;
    final textColor = message.fromUser ? kTextPrimary : kTextSecond;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 310),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: message.fromUser ? null : Border.all(color: kAccentSoft),
            ),
            child: Text(
              message.text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: textColor, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: kBgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kAccentSoft),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (index) => _TypingDot(offset: _dotOffset(index)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _dotOffset(int index) {
    final progress = (_controller.value + (index * 0.18)) % 1;
    return progress < 0.5 ? -4 * progress : -4 * (1 - progress);
  }
}

class _TypingDot extends StatelessWidget {
  const _TypingDot({required this.offset});

  final double offset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        width: 7,
        height: 7,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: const BoxDecoration(
          color: kTextSecond,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;
}
