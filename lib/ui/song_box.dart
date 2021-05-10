import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/controller/file_controller.dart';
import 'package:iidx_simple_manager/main.dart';
import 'package:iidx_simple_manager/model/user_song_parameter.dart';
import 'package:iidx_simple_manager/ui/song_info_dialog.dart';
import '../model/song_info.dart';
import 'dart:convert' as convert;

class SongBox extends StatefulWidget {
  SongBox({Key key, this.info}) : super(key: key);
  SongInfo info;
  @override
  _SongBoxState createState() => _SongBoxState();
}

class _SongBoxState extends State<SongBox> {
  UserSongParameter parameter;
  @override
  void initState() {
    super.initState();
    parameter = MyApp.getFromKey(widget.info.songName);
  }

  void changeInfo(SongInfo _info) {
    setState(() {
      widget.info = _info;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    var isExistsUserData = MyApp.userParameterIsExist(widget.info.songName);
    //難易度表に新しい曲が追加されるとユーザーデータが存在しないことになるから新しく作る
    if (isExistsUserData) {
      parameter = MyApp.getFromKey(widget.info.songName);
    } else {
      print(widget.info.songName);
      parameter = UserSongParameter.initData(widget.info);
      MyApp.userSongParameter.add(parameter);
    }

    return Container(
      child: GestureDetector(
        //カードがタップされたときにダイアログで曲の情報を表示
        onTap: () async {
          showDialog(
              context: context,
              builder: (context) {
                return SongInfoDialog(
                  info: widget.info,
                  callback: changeInfo,
                );
              }).then((value) async {
            var songSaveParameter = convert.jsonEncode(MyApp.userSongParameter);
            await FileController.writeStrings(
                "UserSongParameter.json", songSaveParameter);
          });
        },
        child: Card(
          color: lamp2Color[parameter.lamp],
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.info.songName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    Text('Rank:${parameter.getRank()}'),
                    Text('BP:${parameter.getBP()}'),
                    SizedBox(
                      width: 2,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
