import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/typedefs.dart';

class Songlist extends StatelessWidget {
  final int idx;
  final Play play;

  Songlist({this.play, this.idx}) : assert(play != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: musicStore.songlist.length,
      itemBuilder: (cxt, i) {
        var item = musicStore.songlist[i];
        return ListTile(
          onTap: () {
            this.play(i);
          },
          leading: this.idx == i ? Icon(Icons.arrow_forward, color: Colors.lightBlueAccent) : Text('$i'),
          title: Text(item['name']),
          subtitle: Text(item['songer']),
          trailing: Text('${item['duration']}'),
        );
      },
    );
  }
}
