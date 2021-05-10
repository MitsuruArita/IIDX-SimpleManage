import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/model/song_info.dart';
import 'package:iidx_simple_manager/ui/difficulty_table.dart';

class DifficultyTableManager extends StatefulWidget {
  DifficultyTableManager(
      {Key key, this.title, this.songInfo, this.level, this.tableType})
      : super(key: key);
  List<SongInfo> songInfo;
  final String title;
  int level;
  String tableType;
  @override
  _DifficultyTableManagereState createState() =>
      _DifficultyTableManagereState();
}

class _DifficultyTableManagereState extends State<DifficultyTableManager> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: DifficultyTable(
      songInfos: widget.songInfo,
      level: widget.level,
      tableType: widget.tableType,
    ));
  }
}
