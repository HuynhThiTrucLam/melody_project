import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AudioDownloadService {
  final Dio _dio = Dio();

  // Get the local file path for a given audio file
  Future<String> getLocalFilePath(String songId) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/audio_files');

    // Create the directory if it doesn't exist
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    return '${audioDir.path}/$songId.mp3';
  }

  // Check if the audio file already exists locally
  Future<bool> doesFileExist(String songId) async {
    final filePath = await getLocalFilePath(songId);
    return File(filePath).exists();
  }

  // Download the audio file and store it locally
  Future<String> downloadAudio(
    String songId,
    String audioUrl, {
    Function(double)? onProgress,
  }) async {
    try {
      // Get the file path
      final filePath = await getLocalFilePath(songId);
      final file = File(filePath);

      // Check if file already exists
      if (await file.exists()) {
        debugPrint('Audio file already exists locally: $filePath');
        return filePath;
      }

      debugPrint('Downloading audio file: $audioUrl');

      // Download the file
      await _dio.download(
        audioUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            debugPrint(
              'Download progress: ${(progress * 100).toStringAsFixed(0)}%',
            );
            onProgress?.call(progress);
          }
        },
      );

      debugPrint('Audio file downloaded to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error downloading audio file: $e');
      rethrow;
    }
  }

  // Clear the cached audio files
  Future<void> clearCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/audio_files');

      if (await audioDir.exists()) {
        await audioDir.delete(recursive: true);
        debugPrint('Audio cache cleared');
      }
    } catch (e) {
      debugPrint('Error clearing audio cache: $e');
    }
  }
}
