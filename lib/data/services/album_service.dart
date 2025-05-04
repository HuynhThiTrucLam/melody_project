import 'dart:async';

import 'package:MELODY/data/models/BE/album_data.dart';

class AlbumService {
  // Simulate API delay
  Future<List<AlbumData>> getTopAlbums() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the list of top albums (mockdata)
    return AlbumDataList.albums;
  }

  Future<List<AlbumData>> getTopAlbumsByRegion(String region) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the list of top albums by category (mockdata)
    return AlbumDataList.albums
        .where((album) => album.region == region)
        .toList();
  }

  // Get album detail by ID
  Future<AlbumData> getAlbumbyID(String albumId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the album detail (mockdata)
    return AlbumDataList.albums.firstWhere((album) => album.id == albumId);
  }
}
