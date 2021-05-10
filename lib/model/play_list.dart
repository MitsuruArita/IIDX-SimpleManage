import 'package:iidx_simple_manager/controller/file_controller.dart';
import 'package:iidx_simple_manager/model/song_info.dart';
import 'dart:convert' as convert;

//NOTE:いろいろな種類のリストを作れるようにしたい
//ex. hardねらい用のリストとか
class PlayList {
  static final String playlist_filename = "PlayList.json";
  static List<SongInfo> playList = List<SongInfo>();
  int get getSize => playList.length;
  static bool isContain(String name) {
    return playList.where((element) => element.songName == name).isNotEmpty;
  }

  static void loadPlayLists() async {
    var fileExists = await FileController.fileExists(playlist_filename);
    if (fileExists) {
      var playListJsonString =
          await FileController.readStrings(playlist_filename);
      var playListJson = convert.jsonDecode(playListJsonString) as List;
      playList = playListJson.map((json) => SongInfo.convert(json)).toList();
    }
  }

  static bool addPlayList(SongInfo info) {
    if (isContain(info.songName) == false) {
      playList.add(info);
      //プレイリストを保存
      savePlayList();
      return true;
    } else {
      return false;
    }
  }

  static void savePlayList() async {
    var playListJson = convert.jsonEncode(playList);
    await FileController.writeStrings(playlist_filename, playListJson);
  }
}
