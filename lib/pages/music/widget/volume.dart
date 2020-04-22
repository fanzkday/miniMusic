import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/pages/music/typedefs.dart';

class Volume extends StatelessWidget {
  final OnChanged onChanged;

  Volume({this.onChanged}) : assert(onChanged != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      margin: EdgeInsets.only(top: 15.0, left: 20.0),
      child: Row(
        children: <Widget>[
          Text('音量'),
          Expanded(
            child: Slider(
              value: musicSto.volume,
              label: '${musicSto.volume}',
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                musicSto.refresh(() {
                  musicSto.volume = value.floorToDouble();
                  onChanged(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
