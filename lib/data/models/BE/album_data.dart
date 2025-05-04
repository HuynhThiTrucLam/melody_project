import 'package:MELODY/data/models/BE/music_data.dart';
import 'package:MELODY/data/models/UI/block_data.dart';
import 'package:MELODY/data/models/UI/fiter_tab.dart';

class AlbumData {
  final String id;
  final String title;
  final String artist;
  final String artistImage;
  final String coverImage;
  final int songCount;
  final int totalListens;
  final String releaseDate;
  final Filter region;
  final String? description;
  final List<BlockData> songs;

  AlbumData({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistImage,
    required this.coverImage,
    required this.songCount,
    required this.totalListens,
    required this.releaseDate,
    required this.region,
    this.description,
    required this.songs,
  });
}

class AlbumDataList {
  static final List<AlbumData> albums = [
    AlbumData(
      id: 'a1',
      title: 'Origins',
      artist: 'Imagine Dragons',
      artistImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 14,
      totalListens: 5280000,
      releaseDate: '20/03/2020',
      region: Filter(code: "usuk", name: "US/UK"),
      description:
          'The album "Origins" by Imagine Dragons features a mix of rock and pop elements, showcasing the band\'s signature sound with anthemic choruses and introspective lyrics. It includes hit singles like "Natural" and "Bad Liar," exploring themes of resilience and self-discovery.',
      songs: [
        BlockData(
          id: '4',
          name: 'Hãy Trao Cho Anh',
          subText: 'Sơn Tùng M-TP',
          listener: 9000000,
          avatarUrl:
              'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2019/7/1/741911/Hay-Trao-Cho-Anh.jpg',
          isVerified: true,
        ),
        BlockData(
          id: '5',
          name: 'Chúng Ta Không Thuộc Về Nhau',
          subText: 'Sơn Tùng M-TP',
          listener: 7000000,
          avatarUrl:
              'https://avatar-ex-swe.nixcdn.com/mv/2016/08/04/c/e/1/9/1470277194346_640.jpg',
          isVerified: true,
        ),
      ],
    ),
    AlbumData(
      id: 'a2',
      title: 'Origins',
      artist: 'Imagine Dragons',
      artistImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 11,
      totalListens: 3750000,
      releaseDate: '27/03/2020',
      region: Filter(code: "usuk", name: "US/UK"),
      description:
          'The album "Origins" by Imagine Dragons features a mix of rock and pop elements, showcasing the band\'s signature sound with anthemic choruses and introspective lyrics. It includes hit singles like "Natural" and "Bad Liar," exploring themes of resilience and self-discovery.',
      songs: [
        BlockData(
          id: '6',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
        BlockData(
          id: '7',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
      ],
    ),
    AlbumData(
      id: 'a3',
      title: 'Origins',
      artist: 'Imagine Dragons',
      artistImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 8,
      totalListens: 7200000,
      releaseDate: '20/11/2020',
      region: Filter(code: "usuk", name: "US/UK"),
      description:
          'The album "Origins" by Imagine Dragons features a mix of rock and pop elements, showcasing the band\'s signature sound with anthemic choruses and introspective lyrics. It includes hit singles like "Natural" and "Bad Liar," exploring themes of resilience and self-discovery.',
      songs: [
        BlockData(
          id: '8',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
        BlockData(
          id: '9',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
      ],
    ),
    AlbumData(
      id: 'a4',
      title: 'Origins',
      artist: 'Imagine Dragons',
      artistImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      coverImage:
          'https://m.media-amazon.com/images/I/913fRR9Dk5L._UF1000,1000_QL80_.jpg',
      songCount: 11,
      totalListens: 4850000,
      releaseDate: '21/05/2021',
      region: Filter(code: "usuk", name: "US/UK"),
      description:
          'The album "Origins" by Imagine Dragons features a mix of rock and pop elements, showcasing the band\'s signature sound with anthemic choruses and introspective lyrics. It includes hit singles like "Natural" and "Bad Liar," exploring themes of resilience and self-discovery.',
      songs: [
        BlockData(
          id: '10',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
        BlockData(
          id: '11',
          name: 'Đừng Làm Trái Tim Anh Đau',
          subText: 'Album • Sơn Tùng M-TP',
          listener: 3000000,
          avatarUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZZ_UkbdOdfppyfayhRU_0GOh4umJkXaAzYg&s',
          isVerified: true,
        ),
      ],
    ),
    AlbumData(
      id: 'a5',
      title: 'Vũ trụ cò bay',
      artist: 'Phương Mỹ Chi',
      artistImage: 'https://2saigon.vn/wp-content/uploads/2023/09/A-1077.jpeg',
      coverImage: 'https://rgb.vn/wp-content/uploads/2023/10/34.jpg',
      songCount: 10,
      totalListens: 6200000,
      releaseDate: '20/03/2022',
      region: Filter(code: "vietnam", name: "Việt Nam"),
      description:
          'Album "Vũ trụ cò bay" by Phương Mỹ Chi features a collection of heartfelt Vietnamese songs that blend traditional melodies with contemporary arrangements. The album showcases the artist\'s powerful vocals and emotional delivery, making it a must-listen for fans of Vietnamese pop music.',
      songs: [
        BlockData(
          id: '12',
          name: 'Hãy Trao Cho Anh',
          subText: 'Sơn Tùng M-TP',
          listener: 9000000,
          avatarUrl:
              'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2019/7/1/741911/Hay-Trao-Cho-Anh.jpg',
          isVerified: true,
        ),
        BlockData(
          id: '13',
          name: 'Chúng Ta Không Thuộc Về Nhau',
          subText: 'Sơn Tùng M-TP',
          listener: 7000000,
          avatarUrl:
              'https://avatar-ex-swe.nixcdn.com/mv/2016/08/04/c/e/1/9/1470277194346_640.jpg',
          isVerified: true,
        ),
      ],
    ),
  ];
}
