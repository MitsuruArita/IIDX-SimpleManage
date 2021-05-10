import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/controller/difficulty_table_manager.dart';
import 'package:iidx_simple_manager/controller/play_list_manager.dart';
import 'package:iidx_simple_manager/model/song_info.dart';
import 'package:iidx_simple_manager/ui/load_user_score_from_text.dart';
import 'package:iidx_simple_manager/ui/select_difficulty.dart';

class PageManager extends StatefulWidget {
  PageManager({Key key, this.loadData});
  List<SongInfo> loadData;
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  int _selectedIndex = 0;
  int level = 12;
  String tableType = "NormalDifficulty";
  List<Widget> _pageList;
  @override
  void initState() {
    super.initState();
    _pageList = [
      DifficultyTableManager(
          title: '難易度表',
          songInfo: widget.loadData,
          level: this.level,
          tableType: this.tableType),
      //リスト用のウィジェットを後で追加
      PlayListManager(),
    ];
  }

  void setTableStat(int level, String type) {
    setState(() {
      this.level = level;
      this.tableType = type;
      _pageList[0] = DifficultyTableManager(
          title: '難易度表',
          songInfo: widget.loadData,
          level: this.level,
          tableType: this.tableType);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _popupItems = ["スコア読み込み", "難易度表更新"];
    return Scaffold(
      appBar: AppBar(title: Text("サンプル"), actions: <Widget>[
        PopupMenuButton<String>(onSelected: (String s) {
          if (s == "score") {
            showDialog(
                context: context,
                builder: (context) {
                  return LoadUserScoreFromText();
                }).then((value) {
              //再描画
              if (value == true) {
                setTableStat(this.level, this.tableType);
              }
            });
          }
        }, itemBuilder: (BuildContext context) {
          return _popupItems.map((String s) {
            return PopupMenuItem(
              child: Text(s),
              value: "score",
            );
          }).toList();
        }),
      ]),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.blue,
              child: SizedBox(
                height: 50,
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      '難易度表変更',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )),
              ),
            ),
            SelectDifficulty.getTile(context, "11ノマゲ", Colors.blue,
                () => setTableStat(11, "NormalDifficulty")),
            SelectDifficulty.getTile(context, "11ハード", Colors.red,
                () => setTableStat(11, "HardDifficulty")),
            SelectDifficulty.getTile(context, "12ノマゲ", Colors.blue,
                () => setTableStat(12, "NormalDifficulty")),
            SelectDifficulty.getTile(context, "12ハード", Colors.red,
                () => setTableStat(12, "HardDifficulty")),
            SelectDifficulty.getTile(context, "11名前順", Colors.white, () => {}),
            SelectDifficulty.getTile(context, "12名前順", Colors.white, () => {}),
            /*
            ListTile(
              title: Text("設定"),
              onTap: () => {},
              leading: Icon(Icons.ac_unit),
              //trailing: Icon(Icons.ac_unit),
            )
            */
          ],
        ),
      ),
      body: _pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: '難易度表',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'リスト',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
