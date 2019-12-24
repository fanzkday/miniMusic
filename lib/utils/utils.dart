import 'dart:ui';

class Adapter {
  static double px(double pixel) {
    final double width = window.physicalSize.width;
    // 1080.0 为UI出图的尺寸
    final double scale = width / 1080.0;
    final uiToScreen = pixel * scale;
    final pxToDp = uiToScreen / window.devicePixelRatio;
    return pxToDp;
  }
}

class Utils {
  static List<List<T>> split<T>(List<T> data, int interval) {
    List<List<T>> result = [];
    List<T> temp = [];
    for (var i = 0; i < data.length - 1; i++) {
      temp.add(data[i]);
      if ((i + 1) % interval == 0) {
        result.add(temp);
        temp = [];
      }
    }
    if (temp.length > 0) {
      result.add(temp);
    }
    return result;
  }

  // 毫秒转市场 3:25
  static String msToDt(int milliseconds) {
    var secondsTotal = Duration(milliseconds: milliseconds).inSeconds;
    var minutes = Duration(milliseconds: milliseconds).inMinutes;
    var seconds = (secondsTotal - minutes * 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
