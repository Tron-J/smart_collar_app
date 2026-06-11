String classifyBehavior(int activityIndex) {
  if (activityIndex <= 15) return 'resting';
  if (activityIndex <= 65) return 'grazing';
  return 'running';
}
