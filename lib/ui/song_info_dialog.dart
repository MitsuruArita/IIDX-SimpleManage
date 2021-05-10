import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/main.dart';
import 'package:iidx_simple_manager/model/play_list.dart';
import 'package:iidx_simple_manager/model/user_song_parameter.dart';
import '../model/song_info.dart';

class SongInfoDialog extends StatefulWidget {
  SongInfoDialog({
    Key key,
    this.info,
    this.callback,
  }) : super(key: key);
  Function callback;
  final SongInfo info;
  @override
  _SongInfoDialogState createState() => _SongInfoDialogState();
}

class _SongInfoDialogState extends State<SongInfoDialog> {
  Lamp lamp;
  PlayOption option;
  String memo;
  bool isFirst = true;
  UserSongParameter parameter;
  @override
  void initState() {
    //songinfoとparameterを結びつける
    parameter = MyApp.getFromKey(widget.info.songName);
    lamp = parameter.lamp;
    option = parameter.option;
    memo = parameter.memo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        widget.info.songName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text("ノマゲ:${widget.info.normalDifficulty}"),
                  SizedBox(
                    width: 15,
                  ),
                  Text("ハード:${widget.info.hardDifficulty}"),
                ],
              ),
              infoDialogCard(widget.info),
              //メモ入力とリスト追加
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'メモを入力',
                ),
                controller: isFirst ? TextEditingController(text: memo) : null,
                maxLines: 5,
                onChanged: memoChanged,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton.icon(
                  onPressed: () {
                    PlayList.addPlayList(widget.info);
                  },
                  icon: Icon(Icons.view_list),
                  label: const Text("リストに追加"),
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void lampChange(Lamp _lamp) {
    parameter.lamp = _lamp;
    parameter.lampStr = _lamp.toString();
    //あとでユーザーデータ更新する
    widget.callback(widget.info);
    setState(() {
      lamp = _lamp;
    });
  }

  void optionChange(PlayOption _option) {
    parameter.option = _option;
    parameter.optionStr = _option.toString();
    //あとでユーザーデータ更新する
    widget.callback(widget.info);
    setState(() {
      option = _option;
    });
  }

  void memoChanged(String s) {
    parameter.memo = s;
    isFirst = false;
    setState(() {
      memo = s;
    });
  }

  Widget infoDialogCard(SongInfo songInfo) {
    return Card(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level:${songInfo.level}'),
                Text('Score:${parameter.getScore()}'),
                Text('Rank:${parameter.getRank()}'),
                Text('BP:${parameter.getBP()}'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Lamp:"),
                    DropdownButton<Lamp>(
                        value: lamp,
                        onChanged: lampChange,
                        items: Lamp.values.map((Lamp e) {
                          return DropdownMenuItem<Lamp>(
                              value: e,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: lamp2Color[e],
                                  ),
                                  Text(UserSongParameter.enumToString(e))
                                ],
                              ));
                        }).toList()),
                  ],
                ),
                Row(
                  children: [
                    Text("Option:"),
                    DropdownButton<PlayOption>(
                        value: option,
                        onChanged: optionChange,
                        items: PlayOption.values.map((PlayOption e) {
                          return DropdownMenuItem<PlayOption>(
                              value: e,
                              child: Text(UserSongParameter.enumToString(e)));
                        }).toList()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
