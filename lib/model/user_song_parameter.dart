import 'package:iidx_simple_manager/controller/file_controller.dart';
import 'package:iidx_simple_manager/main.dart';
import 'package:iidx_simple_manager/model/song_info.dart';
import 'dart:convert' as convert;

class UserSongParameter {
  String name;
  int score;
  Rank rank;
  String rankStr;
  int bp;
  Lamp lamp;
  String lampStr;
  PlayOption option;
  String optionStr;
  String memo;

  String getRank() => enumToString(rank) == "None" ? "-" : enumToString(rank);
  String getBP() => (bp == null ? "-" : bp.toString());
  String getScore() => (score == null ? "0" : score.toString());
  String getLamp() => enumToString(lamp);
  String getOption() => enumToString(option);

  static int normalizeBP(dynamic officialMissCount) {
    String officialMissCountStr = officialMissCount.toString();
    return officialMissCountStr == "---"
        ? null
        : int.parse(officialMissCountStr);
  }

  static Rank normalizeRank(dynamic officialRank) {
    String officialRankStr = officialRank.toString();
    return getRankFromString("Rank." + officialRankStr);
  }

  static Lamp normalizeLamp(dynamic officialLamp) {
    String officialLampStr = officialLamp.toString();
    return getLampFromString("Lamp." + officialToRegular[officialLampStr]);
  }

  //jsonなかったら初期化
  UserSongParameter.init(SongInfo info) {
    this.name = info.songName;
    this.score = null;
    this.rank = Rank.None;
    this.rankStr = "Rank.None";
    this.bp = null;
    this.lamp = Lamp.NP;
    this.lampStr = "Lamp.NP";
    this.option = PlayOption.ANY;
    this.optionStr = "PlayOption.ANY";
    this.memo = "";
  }
  UserSongParameter.initWithOfficialData(
      this.name, this.score, this.rank, this.bp, this.lamp) {
    this.rankStr = "Rank." + enumToString(rank);
    this.rankStr = "Lamp." + enumToString(lamp);
    this.option = PlayOption.ANY;
    this.optionStr = "PlayOption.ANY";
    this.memo = "";
  }
  factory UserSongParameter.initData(SongInfo info) {
    return UserSongParameter.init(info);
  }
  //enumをtoStringしたらxxx.xxxってなるから分割する
  static String enumToString<T>(T _enum) {
    return _enum.toString().split(".").last;
  }

  //enum型をjsonから取得するString型をenum型に戻す
  void stringToEnum() {
    this.rank = getRankFromString(this.rankStr);
    this.lamp = getLampFromString(this.lampStr);
    this.option = getPlayOptionFromString(this.optionStr);
  }

  static Rank getRankFromString(String rankAsString) {
    for (Rank r in Rank.values) {
      if (r.toString() == rankAsString) {
        return r;
      }
    }
    return Rank.None;
  }

  static Lamp getLampFromString(String lampAsString) {
    for (Lamp l in Lamp.values) {
      if (l.toString() == lampAsString) {
        return l;
      }
    }
    return Lamp.NP;
  }

  static PlayOption getPlayOptionFromString(String lampAsString) {
    for (PlayOption l in PlayOption.values) {
      if (l.toString() == lampAsString) {
        return l;
      }
    }
    return PlayOption.ANY;
  }

  //公式のデータからユーザーパラメーターを更新
  //すでに存在する曲のデータはメモとオプション以外を上書き
  //存在しない曲はあたらしく追加する
  static Future<void> updateParameterFromOfficialFormat(
      List<List<dynamic>> officialData) async {
    const int csv_title_index = 1; //曲タイトルの列番号
    const List<int> csv_difficuty_index = [
      /*begginer*/ 5,
      /*normal*/ 12,
      /*hyper*/ 19,
      /*another*/ 26,
      /*leggendaria*/ 33
    ];
    for (var data in officialData) {
      String songTitle = data[csv_title_index].toString();
      String humenTitle = songTitle;
      UserSongParameter parameter;
      //どの難易度が12かチェック
      if (data[csv_difficuty_index[2]] == 12) {
        //hyper
        humenTitle = songTitle + "[H]";
        parameter = MyApp.getFromKey(humenTitle);
        updateHumenParameter(parameter, data, humenTitle, /*基準列番号*/ 19);
      }

      if (data[csv_difficuty_index[3]] == 12) {
        //another
        humenTitle = songTitle;
        parameter = MyApp.getFromKey(humenTitle);
        updateHumenParameter(parameter, data, humenTitle, /*基準列番号*/ 26);
      }

      if (data[csv_difficuty_index[4]] == 12) {
        //haka
        humenTitle = songTitle + "[L]";
        parameter = MyApp.getFromKey(humenTitle);
        updateHumenParameter(parameter, data, humenTitle, /*基準列番号*/ 33);
      }
    }
    //jsonに保存
    var songSaveParameter = convert.jsonEncode(MyApp.userSongParameter);
    await FileController.writeStrings(
        "UserSongParameter.json", songSaveParameter);
    //print(songSaveParameter);
    return;
  }

  //譜面が存在する場合は更新　存在しない場合は新たに作成する
  static bool updateHumenParameter(UserSongParameter parameter,
      List<dynamic> songData, String title, int baseIndex) {
    bool isExist = (parameter != null);
    int score = songData[baseIndex + 1];
    Rank rank = normalizeRank(songData[baseIndex + 6]);
    int bp = normalizeBP(songData[baseIndex + 4]);
    Lamp lamp = normalizeLamp(songData[baseIndex + 5]);
    if (isExist) {
      parameter.score = score;
      parameter.bp = bp;
      parameter.rank = rank;
      parameter.rankStr = "Rank." + enumToString(rank);
      parameter.lamp = lamp;
      parameter.lampStr = "Lamp." + enumToString(lamp);
    } else {
      UserSongParameter parameter = new UserSongParameter.initWithOfficialData(
          title, score, rank, bp, lamp);
      //新しく追加する
      MyApp.userSongParameter.add(parameter);
    }
    return isExist;
  }

  UserSongParameter.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        score = json['score'],
        rankStr = json['rank'],
        bp = json['bp'],
        lampStr = json['lamp'],
        optionStr = json['option'],
        memo = json['memo'];

  dynamic toJson() => {
        'name': name,
        'score': score,
        'rank': rankStr,
        'bp': bp,
        'lamp': lampStr,
        'option': optionStr,
        'memo': memo
      };
}
