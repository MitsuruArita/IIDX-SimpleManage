import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/model/song_dto.dart';
import '../model/song_info.dart';
import 'song_box.dart';

class DifficultyBox extends StatelessWidget {
  List<SongInfo> songInfo;
  final String tableType;
  final String difficulty;
  List<SongInfo> filteredSongInfo = new List<SongInfo>();
  DifficultyBox({Key key, songInfo, tableType, difficulty})
      : this.init(
          songInfo: songInfo,
          tableType: tableType,
          difficulty: difficulty,
        );
  //指定された難易度のsonginfoだけ取得
  DifficultyBox.init({Key key, this.songInfo, this.tableType, this.difficulty})
      : super(key: key) {
    if (tableType == "NormalDifficulty") {
      songInfo = songInfo
          .where((info) => info.normalDifficulty == this.difficulty)
          .toList();
    } else if (tableType == "HardDifficulty") {
      songInfo = songInfo
          .where((info) => info.hardDifficulty == this.difficulty)
          .toList();
    }
    //文字列ソート
    songInfo.sort((a, b) => a.songName.compareTo(b.songName));
  }
  @override
  Widget build(BuildContext buildContext) {
    return Card(
      child: Container(
        color: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              color: Color.fromRGBO(80, 80, 80, 1),
              child: Center(
                child: Text(
                  this.difficulty,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            _songCardGrid(),
          ],
        ),
      ),
    );
  }

  //その難易度のカードたちをグリッドで返す
  Widget _songCardGrid() {
    //カードのリスト
    final List<Widget> contentWidgets = List<Widget>();
    songInfo.forEach((i) {
      contentWidgets.add(SongBox(info: i));
    });
    //カードのリストをグリッドにまとめる
    return Container(
        child: GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 1.8,
      crossAxisCount: 3,
      children: contentWidgets,
    ));
  }
}
