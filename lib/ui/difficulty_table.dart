import 'package:flutter/material.dart';
import 'package:iidx_simple_manager/model/song_dto.dart';
import 'package:iidx_simple_manager/model/song_info.dart';

import 'difficulty_box.dart';

//難易度の表リストをつくる
class DifficultyTable extends StatefulWidget {
  final List<SongInfo> songInfos;
  final int level;
  final String tableType;
  DifficultyTable({Key key, this.songInfos, this.level, this.tableType})
      : super(key: key);
  @override
  _DifficultyTableState createState() => _DifficultyTableState();
}

class _DifficultyTableState extends State<DifficultyTable> {
  @override
  Widget build(BuildContext context) {
    var list = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var target =
            widget.songInfos.where((element) => element.level == widget.level);
        if (widget.tableType == "NormalDifficulty") {
          target = target.where((element) =>
              element.normalDifficulty == SongDTO.difficulties[index]);
        } else if (widget.tableType == "HardDifficulty") {
          target = target.where((element) =>
              element.hardDifficulty == SongDTO.difficulties[index]);
        }
        //何もないときは無をいれる
        if (target.isEmpty) {
          return SizedBox(
            height: 0,
          );
        } else {
          return Column(
            children: [
              DifficultyBox(
                difficulty: SongDTO.difficulties[index],
                tableType: widget.tableType,
                songInfo: FilterSongInfo(widget.songInfos, widget.level),
              ),
              SizedBox(
                height: 20,
              )
            ],
          );
        }
      },
      itemCount: SongDTO.difficulties.length,
    );
    return list;
  }

  //レベルで絞る
  List<SongInfo> FilterSongInfo(List<SongInfo> songInfos, int level) {
    var s = songInfos.where((info) => info.level == level).toList();
    return s;
  }
}
