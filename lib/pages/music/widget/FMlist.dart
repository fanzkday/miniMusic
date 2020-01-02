import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/typedefs.dart';

class FMList extends StatefulWidget {
  final Play play;

  FMList({this.play});

  @override
  _FMListState createState() => _FMListState();
}

class _FMListState extends State<FMList> {
  AudioPlayer audioPlayer = musicStore.audioPlayer;

  TextStyle textStyle = const TextStyle(fontSize: 24.0, color: Colors.blueAccent);

  PersistentBottomSheetController bottomSheet;

  @override
  void initState() {
    this.playNext();
    audioPlayer.onPlayerCompletion.listen((event) {
      this.playNext();
    });
    super.initState();
  }

  playNext() {
    audioPlayer.release();
    musicStore.getFMSong().then((url) async {
      if (url.isNotEmpty) {
        await audioPlayer.play(url);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var color = Colors.grey;
    Map map = musicStore.fmsong ?? {'name': '', 'songer': '', 'duration': ''};
    return Container(
      margin: EdgeInsets.only(bottom: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text(map['name'], style: textStyle, overflow: TextOverflow.ellipsis)),
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
                icon: Icon(IconData(0xe63d, fontFamily: 'iconfont'), size: 40.0),
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
                              musicStore.trackSong(item['id'], musicStore.fmsong['id'], 'add');
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
                icon: Icon(audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow),
                tooltip: '播放',
                iconSize: 50,
                color: color,
                onPressed: () async {
                  if (audioPlayer.state == AudioPlayerState.PLAYING) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                tooltip: '下一首',
                iconSize: 50,
                color: color,
                onPressed: this.playNext,
              )
            ],
          ),
        ],
      ),
    );
  }
}
