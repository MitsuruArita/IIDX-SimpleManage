import 'package:json_annotation/json_annotation.dart';

import 'song_dto.dart';
import 'package:flutter/material.dart';

enum Rank {
  @JsonValue("None")
  None,
  @JsonValue("F")
  F,
  @JsonValue("E")
  E,
  @JsonValue("D")
  D,
  @JsonValue("C")
  C,
  @JsonValue("B")
  B,
  @JsonValue("A")
  A,
  @JsonValue("AA")
  AA,
  @JsonValue("AAA")
  AAA
}

enum Lamp {
  @JsonValue("NP")
  NP,
  @JsonValue("FA")
  FA,
  @JsonValue("AC")
  AC,
  @JsonValue("EC")
  EC,
  @JsonValue("NC")
  NC,
  @JsonValue("HC")
  HC,
  @JsonValue("EX")
  EX,
  @JsonValue("FC")
  FC
}
enum PlayOption {
  @JsonValue("ANY")
  ANY,
  @JsonValue("OFF")
  OFF,
  @JsonValue("RAN")
  RAN,
  @JsonValue("R_RAN")
  R_RAN,
  @JsonValue("S_RAN")
  S_RAN,
  @JsonValue("MIRROR")
  MIRROR
}

Map<String, String> officialToRegular = {
  "NO PLAY": "NP",
  "FAILED": "FA",
  "ASSIST CLEAR": "AC",
  "EASY CLEAR": "EC",
  "CLEAR": "NC",
  "HARD CLEAR": "HC",
  "EXHARD CLEAR": "EX",
  "FULLCOMBO CLEAR": "FC"
};

Map<Lamp, Color> lamp2Color = {
  Lamp.NP: Color.fromRGBO(255, 255, 255, 1),
  Lamp.FA: Color.fromRGBO(170, 170, 170, 1),
  Lamp.AC: Color.fromRGBO(230, 132, 251, 1),
  Lamp.EC: Color.fromRGBO(146, 251, 111, 1),
  Lamp.NC: Color.fromRGBO(109, 234, 252, 1),
  Lamp.HC: Color.fromRGBO(252, 109, 109, 1),
  Lamp.EX: Color.fromRGBO(252, 252, 109, 1),
  Lamp.FC: Color.fromRGBO(252, 184, 109, 1),
};

class SongInfo extends SongDTO {
  SongInfo(SongDTO dto) : super(dto);
  //バカあほ間抜け
  static SongInfo convert(dynamic json) {
    var info = SongInfo(SongDTO.fromJson(json));
    //ユーザーデータからスコアやランプを結びつける
    return info;
  }

  dynamic toJson() => {
        "song_name": songName,
        "level": level,
        "normal_difficulty": normalDifficulty,
        "hard_difficulty": hardDifficulty
      };
}
