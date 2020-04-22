import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/typedefs.dart';

class SongList extends StatelessWidget {
  final Play play;

  SongList({this.play}) : assert(play != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: musicSto.songlist.length,
      itemBuilder: (cxt, i) {
        var item = musicSto.songlist[i];
        return ListTile(
          onTap: () {
            this.play(i);
          },
          leading: musicSto.playIndex == i
              ? Icon(IconData(0xe88f, fontFamily: 'iconfont'),
                  color: Colors.blueAccent)
              : Text('${i + 1}'),
          title: Text(item['name']),
          subtitle: Text(item['songer']),
          trailing: Container(
            width: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${item['duration']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
