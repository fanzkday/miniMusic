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
          leading: this.idx == i ? Icon(IconData(0xe88f, fontFamily: 'iconfont'), color: Colors.blueAccent) : Text('${i + 1}'),
          title: Text(item['name']),
          subtitle: Text(item['songer']),
          trailing: Container(
            width: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${item['duration']}'),
                GestureDetector(
                  onTap: () {
                    musicStore.trackSong(item['playId'], item['id'], 'del');
                  },
                  child: Icon(
                    IconData(0xe63e, fontFamily: 'iconfont'),
                    size: 20.0,
                    color: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
