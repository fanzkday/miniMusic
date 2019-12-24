import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';

typedef OnChanged = void Function(double value);

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
              value: musicStore.volume,
              label: '${musicStore.volume}',
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (value) {
                musicStore.refresh(() {
                  musicStore.volume = value.floorToDouble();
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
