import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';

class Playlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Container(
          height: 20.0,
          margin: EdgeInsets.only(top: 15.0, left: 20.0),
          child: Text('我的歌单'),
        ),
        Container(
          child: Wrap(
            children: musicSto.playlist.map((item) {
              return ListTile(
                onTap: () async {
                  var errMsg = await musicSto.getSonglist(item['id']);
                  musicSto.showSnacker(errMsg);
                },
                dense: true,
                isThreeLine: false,
                leading: Icon(Icons.list),
                title: Text(item['name']),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
