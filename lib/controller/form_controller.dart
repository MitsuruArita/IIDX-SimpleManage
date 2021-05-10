import 'dart:convert' as convert;
import '../model/song_info.dart';
import 'package:http/http.dart' as http;

//https://script.google.com/macros/s/AKfycbzfm8OcmqtBrrQJapuMTbcvaho8ckOK-MZ_48F4_zj8/dev
class FormController {
  static const String chartURL =
      'https://script.google.com/macros/s/AKfycbyk6AjD_6EfNs4Po-3F5uKL9q2XsxmS9257QbIT-bzlq5t6zduQfjTpgg/exec';

  Future<List<SongInfo>> getSongInfo() {
    return http.get(chartURL).then((response) {
      var jsonSongInfo = convert.jsonDecode(response.body) as List;
      var infoList =
          jsonSongInfo.map((json) => SongInfo.convert(json)).toList();
      print(infoList[0]);
      //listのlistをひとつのlistにまとめる
      return infoList;
    });
  }
}
