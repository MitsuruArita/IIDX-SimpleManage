import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileController {
  //保存
  static Future<void> writeStrings(String filename, String content) async {
    var file = await getFilePath(filename);
    file.writeAsString(content);
  }

  static Future<String> readStrings(String filename) async {
    final file = await getFilePath(filename);
    return file.readAsString();
  }

  //ディレクトリ取得
  static Future<File> getFilePath(String filename) async {
    final directory = await getTemporaryDirectory();
    return File(directory.path + "/" + filename);
  }

  //ファイルチェック
  static Future<bool> fileExists(String filename) async {
    var file = await getFilePath(filename);
    var pathName = file.path;
    return File(pathName).exists();
  }
}
