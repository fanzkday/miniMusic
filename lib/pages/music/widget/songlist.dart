import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';

typedef Play = void Function(int value);

class Songlist extends StatelessWidget {
  final int idx;

  final Play play;

  Songlist({this.play, this.idx}) : assert(play != null, idx != null);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: musicStore.songlist
          .asMap()
          .map((i, item) {
            return MapEntry(
              i,
              ListTile(
                onTap: () {
                  this.play(i);
                },
                leading: this.idx == i ? Icon(Icons.arrow_forward, color: Colors.lightBlueAccent) : Text('$i'),
                title: Text(item['name']),
                subtitle: Text(item['songer']),
                trailing: Text('${item['duration']}'),
              ),
            );
          })
          .values
          .toList(),
    );
  }
}
