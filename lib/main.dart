import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter/rendering.dart';
import 'package:miniMusic/pages/music/main.dart';
import 'package:miniMusic/utils/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize( debug: false );

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  debugPaintSizeEnabled = false;

  // 初始化数据库等连接
  await Store.init();
  FlutterError.onError = (FlutterErrorDetails details) {
    print(details);
  };
  runZoned(() {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CloudMusic(),
      ),
    ));
  }, onError: (Object obj, StackTrace stack) {
    print(stack);
  });
}
