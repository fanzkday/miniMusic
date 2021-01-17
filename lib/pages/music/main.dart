import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/widget/login.dart';
import 'package:miniMusic/pages/music/widget/playlist.dart';
import 'package:miniMusic/pages/music/widget/songlist.dart';
import 'package:miniMusic/utils/player.dart';

class CloudMusic extends StatefulWidget {
  @override
  _CloudMusicState createState() => _CloudMusicState();
}

class _CloudMusicState extends State<CloudMusic> {
  bool status = player.status;

  @override
  void initState() {
    musicSto.bind(this);

    musicSto.showSnacker = (String msg) {
      if (msg.isNotEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(msg),
        ));
      }
    };
    musicSto.login();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('云音乐'),
      ),
      bottomSheet: LinearProgressIndicator(
        backgroundColor: Colors.transparent,
        value: player.position,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
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
                  child: ClipOval(
                      child: musicSto.avatar != null
                          ? Image.network(musicSto.avatar)
                          : Text('')),
                ),
              ),
            ),
            Login(),
            Divider(height: 15.0, color: Colors.grey,),
            Playlist()
          ],
        ),
      ),
      body: SongList(play: (int idx) async {
        bool s = await player.play(idx);
        setState(() {
          status = s;
        });
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(status ? Icons.pause : Icons.play_arrow),
        onPressed: () async {
          bool s;
          if (status) {
            s = await player.pause();
          } else {
            s = await player.resume();
          }
          setState(() {
            status = s;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
