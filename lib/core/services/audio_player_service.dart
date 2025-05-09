import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  AudioPlayer get player => _audioPlayer;

  // Initialize audio session
  Future<void> init() async {
    if (_isInitialized) return;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // Handle interruptions (calls, other apps playing audio)
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        // Audio interrupted (e.g., phone call)
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Lower volume temporarily
            _audioPlayer.setVolume(0.5);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            // Pause playback
            _audioPlayer.pause();
            break;
        }
      } else {
        // Interruption ended
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Restore volume
            _audioPlayer.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            // Resume playback if playing before
            _audioPlayer.play();
            break;
          case AudioInterruptionType.unknown:
            // Handle unknown interruptions
            break;
        }
      }
    });

    _isInitialized = true;
  }

  // Load audio from a local file path
  Future<Duration?> loadAudio(String filePath) async {
    try {
      await init();
      await _audioPlayer.setFilePath(filePath);
      return _audioPlayer.duration;
    } catch (e) {
      debugPrint('Error loading audio: $e');
      return null;
    }
  }

  // Play the loaded audio
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  // Pause the audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking audio: $e');
    }
  }

  // Stop and dispose resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  // Get current position stream
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  // Get playback state stream
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
}
