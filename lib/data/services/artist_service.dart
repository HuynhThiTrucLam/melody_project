import 'dart:async';
import 'package:MELODY/data/models/BE/artist_data.dart';

class ArtistService {
  // Simulate API delay
  Future<ArtistData> getArtistById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the artist data if found, or throw exception
    if (ArtistDataList.mockArtists.any((artist) => artist.id == id)) {
      return ArtistDataList.mockArtists.firstWhere((artist) => artist.id == id);
    } else {
      throw Exception("Artist with ID $id not found");
    }
  }

  // Set follow status
  Future<void> setFollowStatus(String artistId, bool isFollowed) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Update the follow status of the artist
    final artist = ArtistDataList.mockArtists.firstWhere(
      (artist) => artist.id == artistId,
    );
    artist.isFollowed = isFollowed;
  }

  // Get similar artists
  Future<List<ArtistData>> getSimilarArtists(String artistId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return a list of similar artists
    return ArtistDataList.mockArtists.toList();
  }
}
