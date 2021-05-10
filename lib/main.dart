import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/controller/file_controller.dart';
import 'package:iidx_simple_manager/model/song_info.dart';
import 'package:iidx_simple_manager/model/user_song_parameter.dart';
import 'controller/form_controller.dart';
import 'dart:convert' as convert;
import 'controller/page_manager.dart';
import 'model/play_list.dart';

List<SongInfo> tableData = new List<SongInfo>();
List<UserSongParameter> _userSongParameter = new List<UserSongParameter>();
//一時的なデバッグ用変数
bool isUpdate = true;

void main() async {
  //mainで時間かかると変なエラーがでるからこれ書いておく
  WidgetsFlutterBinding.ensureInitialized();

  if (isUpdate) {
    //ここで読み込みの処理とかするといいらしい
    await fetchDifficultyTableFromSheet();
  } else {
    //jsonなければ上のシーケンス実行?
    var fileExists = await FileController.fileExists("UserSongInfo.json");
    if (!fileExists)
      await fetchDifficultyTableFromSheet();
    else {
      //デコードしてtableDataにぶち込む
      var songJson = await FileController.readStrings("UserSongInfo.json");
      var jsonSongInfo = convert.jsonDecode(songJson) as List;
      tableData = jsonSongInfo.map((json) => SongInfo.convert(json)).toList();
    }
  }

  //ユーザーパラメーターセット(なければ初期化してjson保存)
  var fileExists = await FileController.fileExists("UserSongParameter.json");
  if (!fileExists) {
    _userSongParameter = List<UserSongParameter>();
    tableData.forEach((element) {
      _userSongParameter.add(UserSongParameter.initData(element));
    });
    var userSongParameterToJson = convert.jsonEncode(_userSongParameter);
    await FileController.writeStrings(
        "UserSongParameter.json", userSongParameterToJson);
  } else {
    //ユーザーデータ読み込み
    var paramJson = await FileController.readStrings("UserSongParameter.json");
    //print(paramJson);
    var jsonParam = convert.jsonDecode(paramJson) as List;
    _userSongParameter =
        jsonParam.map((json) => UserSongParameter.fromJson(json)).toList();
    //文字列をenumになおす
    _userSongParameter.forEach((element) {
      element.stringToEnum();
    });
  }

  //プレイリスト読み込み
  PlayList.loadPlayLists();

  runApp(MyApp());
}

//スプレッドシートから難易度表を取得する関数
//取得後に難易度表情報をローカルに保存する
Future<void> fetchDifficultyTableFromSheet() async {
  var formController = new FormController();
  await formController.getSongInfo().then((value) {
    tableData = value;
  });
  //jsonとしてローカルに保存
  var songSaveData = convert.jsonEncode(tableData);
  //書き込みをまつ
  await FileController.writeStrings("UserSongInfo.json", songSaveData);
}

class MyApp extends StatelessWidget {
  static List<UserSongParameter> userSongParameter = _userSongParameter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      home: PageManager(loadData: tableData),
    );
  }

  //曲名からユーザーパラメーターを呼び出す
  //その曲名が存在しなかったらnullを呼びだす
  static UserSongParameter getFromKey(String s) {
    return userSongParameter.firstWhere((element) => element.name == s,
        orElse: () => null);
  }

  static bool userParameterIsExist(String s) {
    return getFromKey(s) != null;
  }
}
