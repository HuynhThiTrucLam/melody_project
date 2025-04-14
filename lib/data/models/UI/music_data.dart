class MusicData {
  final String id;
  final String name;
  final String artist;
  final String albumArt;
  final String audioUrl; // URL or asset path for the audio file
  final String lyrics; // Full lyrics if available
  final Duration duration; // Full duration of the track
  final int listener;
  final bool isFavorite; // Whether the user marked it as favorite
  final String genre;
  final DateTime releaseDate;

  MusicData({
    required this.id,
    required this.name,
    required this.artist,
    required this.albumArt,
    required this.audioUrl,
    required this.lyrics,
    required this.duration,
    required this.listener,
    this.isFavorite = false,
    this.genre = 'Unknown',
    required this.releaseDate,
  });
}

class MusicDataList {
  static final List<MusicData> musics = [
    MusicData(
      id: '1',
      name: 'Blinding Lights',
      artist: 'The Weeknd',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/e/e6/The_Weeknd_-_Blinding_Lights.png',
      audioUrl: 'https://example.com/audio/blinding_lights.mp3',
      lyrics: 'I said, ooh, I’m blinded by the lights...',
      duration: Duration(minutes: 3, seconds: 20),
      listener: 1580000,
      isFavorite: true,
      genre: 'Synthwave',
      releaseDate: DateTime(2020, 11, 29),
    ),
    MusicData(
      id: '2',
      name: 'Đừng làm trái tim anh đau',
      artist: 'Sơn Tùng M-TP',
      albumArt: 'https://i.ytimg.com/vi/7u4g483WTzw/hq720.jpg',
      audioUrl: 'https://example.com/audio/dung_lam_trai_tim_anh_dau.mp3',
      lyrics: 'Thấy thế thôi vui hơn có quà...',
      duration: Duration(minutes: 4, seconds: 10),
      listener: 980000,
      isFavorite: false,
      genre: 'Pop',
      releaseDate: DateTime(2024, 12, 23),
    ),
    MusicData(
      id: '3',
      name: 'Butter',
      artist: 'BTS',
      albumArt:
          'https://cdnmedia.baotintuc.vn/Upload/YZmStSDTjb0M07hFJ2gA/files/2021/06/22/butter-220621(1).jpg',
      audioUrl: 'https://example.com/audio/butter.mp3',
      lyrics: 'Smooth like butter, like a criminal undercover...',
      duration: Duration(minutes: 2, seconds: 44),
      listener: 2450000,
      isFavorite: true,
      genre: 'K-pop',
      releaseDate: DateTime(2021, 5, 21),
    ),
    MusicData(
      id: '4',
      name: 'Good 4 U',
      artist: 'Olivia Rodrigo',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/5/5c/Olivia_Rodrigo_-_Good_4_U.png',
      audioUrl: 'https://example.com/audio/good_4_u.mp3',
      lyrics: 'Well, good for you, I guess you moved on really easily...',
      duration: Duration(minutes: 2, seconds: 58),
      listener: 1320000,
      isFavorite: false,
      genre: 'Pop punk',
      releaseDate: DateTime(2021, 5, 14),
    ),
    MusicData(
      id: '5',
      name: 'Levitating',
      artist: 'Dua Lipa ft. DaBaby',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/e/e3/Dua_Lipa_-_Levitating.png',
      audioUrl: 'https://example.com/audio/levitating.mp3',
      lyrics: 'If you wanna run away with me, I know a galaxy...',
      duration: Duration(minutes: 3, seconds: 23),
      listener: 870000,
      isFavorite: true,
      genre: 'Disco-pop',
      releaseDate: DateTime(2020, 10, 1),
    ),
    MusicData(
      id: '6',
      name: 'Hoa Nở Không Màu',
      artist: 'Hoài Lâm',
      albumArt: 'https://i.ytimg.com/vi/7u4g483WTzw/hq720.jpg',
      audioUrl: 'https://example.com/audio/hoa_no_khong_mau.mp3',
      lyrics: 'Tình yêu ban đầu đâu ai biết trước sẽ ra sao...',
      duration: Duration(minutes: 5, seconds: 3),
      listener: 1200000,
      isFavorite: false,
      genre: 'Ballad',
      releaseDate: DateTime(2020, 6, 25),
    ),
    MusicData(
      id: '7',
      name: 'Chúng Ta Của Hiện Tại',
      artist: 'Sơn Tùng M-TP',
      albumArt: 'https://i.ytimg.com/vi/7u4g483WTzw/hq720.jpg',
      audioUrl: 'https://example.com/audio/chung_ta_cua_hien_tai.mp3',
      lyrics: 'Chúng ta của hiện tại, là những ngày yêu nhau nhất...',
      duration: Duration(minutes: 6, seconds: 0),
      listener: 3200000,
      isFavorite: true,
      genre: 'Pop Ballad',
      releaseDate: DateTime(2020, 12, 20),
    ),
    MusicData(
      id: '8',
      name: 'Để Mị Nói Cho Mà Nghe',
      artist: 'Hoàng Thùy Linh',
      albumArt: 'https://i.ytimg.com/vi/7u4g483WTzw/hq720.jpg',
      audioUrl: 'https://example.com/audio/de_mi_noi_cho_ma_nghe.mp3',
      lyrics: 'Ai cho Mị yêu tình yêu đậm sâu thế này...',
      duration: Duration(minutes: 3, seconds: 17),
      listener: 950000,
      isFavorite: false,
      genre: 'Folk pop',
      releaseDate: DateTime(2019, 6, 19),
    ),
    MusicData(
      id: '9',
      name: 'Bad Habits',
      artist: 'Ed Sheeran',
      albumArt:
          'https://upload.wikimedia.org/wikipedia/en/3/36/Ed_Sheeran_-_Bad_Habits.png',
      audioUrl: 'https://example.com/audio/bad_habits.mp3',
      lyrics: 'My bad habits lead to late nights ending alone...',
      duration: Duration(minutes: 3, seconds: 50),
      listener: 1750000,
      isFavorite: true,
      genre: 'Dance-pop',
      releaseDate: DateTime(2021, 6, 25),
    ),
    MusicData(
      id: '10',
      name: 'Có Chàng Trai Viết Lên Cây',
      artist: 'Phan Mạnh Quỳnh',
      albumArt: 'https://i.ytimg.com/vi/7u4g483WTzw/hq720.jpg',
      audioUrl: 'https://example.com/audio/co_chang_trai_viet_len_cay.mp3',
      lyrics: 'Có chàng trai viết lên cây, lời yêu thương cô gái ấy...',
      duration: Duration(minutes: 4, seconds: 40),
      listener: 890000,
      isFavorite: true,
      genre: 'Acoustic ballad',
      releaseDate: DateTime(2016, 3, 14),
    ),
  ];
}
