import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/typedefs.dart';

class FMList extends StatelessWidget {
  final TextStyle textStyle = TextStyle(fontSize: 24.0, color: Colors.blueAccent);
  final Play play;

  PersistentBottomSheetController bottomSheet;

  FMList({this.play}) : assert(play != null);

  @override
  Widget build(BuildContext context) {
    musicStore.getFMSonglist(play);
    var color = Colors.grey;
    Map map = musicStore.fmsonglist.length > 0 ? musicStore.fmsonglist[0] : {'name': '', 'songer': '', 'duration': ''};
    return Container(
      margin: EdgeInsets.only(bottom: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              map['name'],
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 25.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(map['songer'], style: textStyle),
              SizedBox(width: 15.0),
              Text(map['duration'], style: textStyle),
            ],
          ),
          SizedBox(height: 25.0),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                iconSize: 50,
                color: color,
                tooltip: '收藏',
                onPressed: () {
                  if (bottomSheet != null) {
                    return;
                  }
                  bottomSheet = Scaffold.of(context).showBottomSheet((cxt) {
                    return Container(
                      height: 150.0,
                      child: ListView(
                        children: musicStore.playlist.map((item) {
                          return ListTile(
                            onTap: () async {
                              bottomSheet.close();
                              String msg = await musicStore.trackSong(item['id'], musicStore.fmsonglist[0]['id']);
                              musicStore.showSnacker(msg);
                            },
                            title: Text(item['name']),
                          );
                        }).toList(),
                      ),
                    );
                  }, backgroundColor: Colors.black12);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_backup_restore),
                tooltip: '播放',
                iconSize: 50,
                color: color,
                onPressed: () {
                  this.play(null);
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                tooltip: '下一首',
                iconSize: 50,
                color: color,
                onPressed: () {
                  musicStore.fmsonglist.removeAt(0);
                  if (musicStore.fmsonglist.length == 0) {
                    musicStore.getFMSonglist(play);
                  } else {
                    musicStore.refresh(() {
                      this.play(null);
                    });
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
