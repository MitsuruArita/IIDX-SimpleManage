import 'package:flutter/material.dart';

class SelectDifficulty {
  //コールバックとかつけるかも
  static Widget getTile(
      BuildContext context, String name, Color color, Function callback) {
    return Container(
      decoration: BoxDecoration(
          //color: Colors.black12,
          //color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black38))),
      child: ListTile(
        leading: Container(
          width: 20,
          height: 20,
          color: color,
        ),
        title: Text(name),
        onTap: () {
          callback();
          Navigator.pop(context);
        },
      ),
    );
  }
}
