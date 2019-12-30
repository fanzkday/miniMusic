import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/widget/FMlist.dart';
import 'package:miniMusic/pages/music/widget/login.dart';
import 'package:miniMusic/pages/music/widget/playlist.dart';
import 'package:miniMusic/pages/music/widget/songlist.dart';
import 'package:miniMusic/pages/music/widget/volume.dart';

class CloudMusic extends StatefulWidget {
  @override
  _CloudMusicState createState() => _CloudMusicState();
}

class _CloudMusicState extends State<CloudMusic> {
  AudioPlayer audioPlayer = musicStore.audioPlayer;

  bool status = false; // false: 停止; true: 运行中

  int tabIdx = 0; // 激活的tab页

  @override
  void initState() {
    musicStore.bind(this);

    audioPlayer.onPlayerCompletion.listen((event) {
      this.play(musicStore.playIndex + 1);
    });
    audioPlayer.setVolume(musicStore.volume / 100);

    musicStore.showSnacker = (String msg) {
      if (msg.isNotEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(msg),
        ));
      }
    };
    musicStore.login();

    super.initState();
  }

  void play(int idx) async {
    var url;
    if (idx == null) {
      url = await musicStore.getSongUrl(musicStore.fmsonglist[0]['id']);
    } else {
      url = await musicStore.getSongUrl(musicStore.songlist[idx]['id']);
    }
    if (url.isNotEmpty) {
      if (idx != null) {
        setState(() {
          musicStore.playIndex = idx;
          this.status = true;
        });
      }
      audioPlayer.release();
      audioPlayer.play(url);
    } else {
      musicStore.showSnacker('获取歌曲失败 | 版权原因不能播放');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('云音乐'),
          bottom: TabBar(
            onTap: (tabIdx) {
              setState(() {
                this.tabIdx = tabIdx;
                if (tabIdx != 2) {
                  audioPlayer.release();
                }
              });
            },
            tabs: <Widget>[
              Tab(text: '听歌'),
              Tab(text: '搜歌'),
              Tab(text: '私人FM'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Center(
                  child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: ClipOval(child: musicStore.avatar != null ? Image.network(musicStore.avatar) : Text('')),
                  ),
                ),
              ),
              Login(),
              Volume(onChanged: (value) {
                audioPlayer.setVolume(value / 100);
              }),
              Playlist()
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Songlist(idx: musicStore.playIndex, play: this.play),
            Text('搜歌'),
            FMList(play: this.play),
          ],
        ),
        floatingActionButton: tabIdx == 2
            ? null
            : FloatingActionButton(
                child: Icon(status ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (musicStore.playIndex == null) {
                    this.play(0);
                  } else if (audioPlayer.state == null) {
                    this.play(musicStore.playIndex);
                  } else {
                    if (status) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.resume();
                    }
                  }

                  setState(() {
                    status = !status;
                  });
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
