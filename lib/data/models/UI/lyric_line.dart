class LyricLine {
  final String text; // The lyric text
  final Duration startTime; // When this line should start displaying
  final Duration endTime; // When this line should stop displaying (optional)

  LyricLine({
    required this.text,
    required this.startTime,
    required this.endTime,
  });

  // Helper to check if a given playback position is within this line's time range
  bool isActiveAt(Duration position) {
    return position >= startTime && position < endTime;
  }
}

class TimestampedLyrics {
  final List<LyricLine> lines;

  TimestampedLyrics({required this.lines});

  // Factory to parse LRC format or generate from plain text
  factory TimestampedLyrics.fromPlainText(
    String plainText,
    Duration songDuration,
  ) {
    final lines =
        plainText.split('\n').where((line) => line.trim().isNotEmpty).toList();

    // If no lyrics, return empty list
    if (lines.isEmpty) {
      return TimestampedLyrics(lines: []);
    }

    // Create evenly distributed timestamps
    final lineCount = lines.length;
    final List<LyricLine> lyricLines = [];

    for (int i = 0; i < lineCount; i++) {
      final startSeconds = (i / lineCount) * songDuration.inSeconds;
      final endSeconds = ((i + 1) / lineCount) * songDuration.inSeconds;

      lyricLines.add(
        LyricLine(
          text: lines[i],
          startTime: Duration(seconds: startSeconds.floor()),
          endTime: Duration(seconds: endSeconds.floor()),
        ),
      );
    }

    return TimestampedLyrics(lines: lyricLines);
  }

  // Find the active line at a given position
  LyricLine? getActiveLine(Duration position) {
    for (var line in lines) {
      if (line.isActiveAt(position)) {
        return line;
      }
    }
    return null;
  }

  // Get the index of the active line
  int getActiveLineIndex(Duration position) {
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].isActiveAt(position)) {
        return i;
      }
    }
    // If no match found, find the closest upcoming line
    for (int i = 0; i < lines.length; i++) {
      if (position < lines[i].startTime) {
        return i > 0 ? i - 1 : 0;
      }
    }
    // If we're past all lines, return the last line
    return lines.isEmpty ? -1 : lines.length - 1;
  }
}
