import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/controller/file_controller.dart';
import 'package:iidx_simple_manager/main.dart';
import 'package:iidx_simple_manager/model/play_list.dart';
import 'package:iidx_simple_manager/model/song_info.dart';
import 'dart:math' as math;
import 'dart:convert' as convert;
import 'package:iidx_simple_manager/ui/song_info_dialog.dart';

class PlayListManager extends StatefulWidget {
  PlayListManager({Key key});
  @override
  _PlayListManager createState() => _PlayListManager();
}

class _PlayListManager extends State<PlayListManager> {
  @override
  Widget build(BuildContext context) {
    if (PlayList.playList == null || PlayList.playList.length == 0) {
      return Center(child: Text("リストに何も登録されていません"));
    } else {
      return ListView.builder(
        itemCount: PlayList.playList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            //なぞ https://qiita.com/kazumaz/items/79c9f4c553d638d555b4
            key: ObjectKey(PlayList.playList[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                PlayList.playList.removeAt(index);
                PlayList.savePlayList();
              });
            },
            background: Container(color: Colors.red),
            secondaryBackground: Container(color: Colors.red),
            child: _playListCard(PlayList.playList[index]),
          );
        },
      );
    }
  }

  Card _playListCard(SongInfo info) {
    return Card(
      child: ListTile(
        title: Text(info.songName),
        //ダイアログを表示
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) {
                return SongInfoDialog(
                  info: info,
                  callback: (SongInfo _) => {},
                );
              }).then((value) async {
            var songSaveParameter = convert.jsonEncode(MyApp.userSongParameter);
            await FileController.writeStrings(
                "UserSongParameter.json", songSaveParameter);
          });
        },
        trailing: Transform(
          transform: Matrix4.rotationY(math.pi),
          child: Icon(Icons.double_arrow),
        ),
      ),
    );
  }
}
