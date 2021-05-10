import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iidx_simple_manager/main.dart';
import 'package:iidx_simple_manager/model/user_song_parameter.dart';

class LoadUserScoreFromText extends StatefulWidget {
  @override
  _LoadUserScoreFromTextState createState() => _LoadUserScoreFromTextState();
}

class _LoadUserScoreFromTextState extends State<LoadUserScoreFromText> {
  String officialScoreText = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var officialScoreTextController =
        TextEditingController(text: officialScoreText);
    return SimpleDialog(
      title: Text("スコア読み込み"),
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //メモ入力とリスト追加
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '公式サイトからテキストを貼り付け',
                ),
                controller: officialScoreTextController,
                maxLines: 5,
                //onChanged: memoChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton.icon(
                      onPressed: () {
                        pasteToTextField();
                      },
                      icon: Icon(Icons.content_paste),
                      label: const Text("貼り付け"),
                      color: Colors.white54,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton.icon(
                      onPressed: () {
                        reflectOfficialScoreData(
                            officialScoreTextController.text);
                      },
                      icon: Icon(Icons.update),
                      label: const Text("反映"),
                      color: Colors.white54,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void pasteToTextField() async {
    final clipboardData = await Clipboard.getData('text/plain');
    setState(() {
      this.officialScoreText = clipboardData.text;
    });
  }

  void reflectOfficialScoreData(String text) {
    final String inputText = text;
    var rowsAsListOfValues =
        const CsvToListConverter().convert(inputText, eol: '\n');
    //TODO:データが正規の形式かチェックする
    //TODO:ロード中みたいなやつをしたい,keyword:FutureBuilder
    var levelFilteredData = rowsAsListOfValues
        .where((element) => checkSongContainsDifficulty(element, 12))
        .toList();
    //ここで保存もされる
    UserSongParameter.updateParameterFromOfficialFormat(levelFilteredData)
        .then((value) => Navigator.pop(context, true));
    //popして前の画面に戻る
    //print(levelFilteredData.length);
  }

  bool checkSongContainsDifficulty(List<dynamic> officialDataLine, int level) {
    const List<int> csv_difficuty_index = [
      /*begginer*/ 5,
      /*normal*/ 12,
      /*hyper*/ 19,
      /*another*/ 26,
      /*leggendaria*/ 33
    ];
    return (officialDataLine[csv_difficuty_index[0]] == level) ||
        (officialDataLine[csv_difficuty_index[1]] == level) ||
        (officialDataLine[csv_difficuty_index[2]] == level) ||
        (officialDataLine[csv_difficuty_index[3]] == level) ||
        (officialDataLine[csv_difficuty_index[4]] == level);
  }
}
