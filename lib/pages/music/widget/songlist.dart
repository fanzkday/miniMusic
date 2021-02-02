import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/typedefs.dart';
import 'package:miniMusic/utils/player.dart';

class SongList extends StatelessWidget {
  final Play play;

  SongList({this.play}) : assert(play != null);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          musicSto.refresh(() {
            musicSto.getSonglist(musicSto.playlistIndex);
          });
        },
        child: ListView.builder(
          itemCount: musicSto.songlist.length,
          itemBuilder: (cxt, i) {
            var item = musicSto.songlist[i];
            return ListTile(
              dense: true,
              onTap: () {
                this.play(i);
              },
              leading: musicSto.playIndex == i
                  ? Icon(Icons.arrow_forward, color: Colors.green)
                  : Text('${i + 1}'),
              title: Text(item.name),
              subtitle: Text(item.songer),
              trailing: Container(
                width: 90.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${item.duration}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    item.isDownload
                        ? Text('已下载', style: TextStyle(color: Colors.green))
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_downward,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              player.download(i);
                            })
                  ],
                ),
              ),
            );
          },
        ));
  }
}
