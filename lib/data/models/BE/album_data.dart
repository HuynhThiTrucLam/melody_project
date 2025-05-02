class AlbumData {
  final String id;
  final String title;
  final String artist;
  final String coverImage;
  final int songCount;
  final int totalListens;
  final String releaseDate;

  AlbumData({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.songCount,
    required this.totalListens,
    required this.releaseDate,
  });
}

class AlbumDataList {
  static final List<AlbumData> albums = [
    AlbumData(
      id: 'a1',
      title: 'Origins',
      artist: 'Imagine Dragons',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 14,
      totalListens: 5280000,
      releaseDate: '20/03/2020',
    ),
    AlbumData(
      id: 'a2',
      title: 'Origins',
      artist: 'Imagine Dragons',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 11,
      totalListens: 3750000,
      releaseDate: '27/03/2020',
    ),
    AlbumData(
      id: 'a3',
      title: 'Origins',
      artist: 'Imagine Dragons',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 8,
      totalListens: 7200000,
      releaseDate: '20/11/2020',
    ),
    AlbumData(
      id: 'a4',
      title: 'Origins',
      artist: 'Imagine Dragons',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 11,
      totalListens: 4850000,
      releaseDate: '21/05/2021',
    ),
  ];
}
