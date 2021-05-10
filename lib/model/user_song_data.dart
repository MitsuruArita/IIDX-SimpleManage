import 'package:iidx_simple_manager/model/song_info.dart';

class UserSongData {
  String name;
  int level;
  String normalDifficulty;
  String hardDifficulty;
  //jsonなかったら初期化
  UserSongData.init(SongInfo info) {
    this.name = info.songName;
    this.level = info.level;
    this.normalDifficulty = info.normalDifficulty;
    this.hardDifficulty = info.hardDifficulty;
  }
  factory UserSongData.initData(SongInfo info) {
    return UserSongData.init(info);
  }
  Map toJson() => {
        'name': name,
        'level': level,
        'normalDifficulty': normalDifficulty,
        'hardDifficulty': hardDifficulty
      };
}
