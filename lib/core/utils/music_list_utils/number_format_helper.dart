String formatListenerCount(int count) {
  if (count >= 1_000_000_000) {
    return '${(count / 1_000_000_000).toStringAsFixed(1)}B';
  } else if (count >= 1_000_000) {
    return '${(count / 1_000_000).toStringAsFixed(1)}M';
  } else if (count >= 1_000) {
    return '${(count / 1_000).toStringAsFixed(1)}K';
  } else {
    return count.toString();
  }
}
