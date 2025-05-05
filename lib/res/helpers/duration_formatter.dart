String formatDuration(int seconds) {
  final int totalMinutes = seconds ~/ 60;
  final int hours = totalMinutes ~/ 60;
  final int minutes = totalMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return '$hours jam $minutes menit';
  } else if (hours > 0) {
    return '$hours jam';
  } else {
    return '$minutes menit';
  }
}
