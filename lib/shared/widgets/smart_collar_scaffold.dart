import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class SmartCollarScaffold extends StatelessWidget {
  const SmartCollarScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDeep,
      appBar: appBar,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
