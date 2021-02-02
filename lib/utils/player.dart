import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:miniMusic/pages/music/store.dart';
import 'package:miniMusic/utils/utils.dart';

class _Player {
  double position = 0.0;

  bool get status {
    return this.audioPlayer.state == AudioPlayerState.PLAYING;
  }

  AudioPlayer audioPlayer = new AudioPlayer()..setVolume(1);

  _Player() {
    this.audioPlayer.onPlayerCompletion.listen((event) {
      this.next();
    });

    this.audioPlayer.onAudioPositionChanged.listen((event) async {
      int d = await this.audioPlayer?.getDuration();
      int p = await this.audioPlayer.getCurrentPosition();

      musicSto.refresh(() {
        this.position = p / d;
      });
    });
  }

  Future<bool> play(int idx) async {
    this.audioPlayer.release();
    String localUrl = await hasLocalMusic(idx);
    String url;
    if (localUrl.isNotEmpty) {
      url = localUrl;
    } else {
      url = await this.getUrl(idx);
    }
    if (url.isNotEmpty) {
      int i = await this.audioPlayer.play(url, isLocal: localUrl.isNotEmpty);
      if (i == 1) {
        musicSto.playIndex = idx;
        musicSto.refresh(() {
          //
        });
      }
    }
    return this.status;
  }

  Future<String> hasLocalMusic(int idx) async {
    String dir = await Utils.downloadPath();
    String filename =
        Utils.formatFilename(musicSto.songlist[idx].name) + '.mp3';
    File mp3 = File(dir + filename);
    if (mp3.existsSync()) {
      return mp3.path;
    }
    return '';
  }

  Future<bool> pause() async {
    await this.audioPlayer.pause();
    return this.status;
  }

  Future<bool> resume() async {
    if (this.audioPlayer.state == null ||
        this.audioPlayer.state == AudioPlayerState.STOPPED) {
      await this.play(musicSto.playIndex);
    } else {
      await this.audioPlayer.resume();
    }
    return this.status;
  }

  Future<bool> next() async {
    await this.play(musicSto.playIndex + 1);
    return this.status;
  }

  void setVolume(double volume) {
    this.audioPlayer.setVolume(volume / 100);
  }

  Future<String> getUrl(int idx) async {
    String url = await musicSto.getSongUrl(musicSto.songlist[idx].id);
    if (url.isEmpty) {
      musicSto.showSnacker('获取歌曲失败 | 版权原因不能播放');
      musicSto.playIndex += 1;
      this.next();
      return '';
    }
    return url;
  }

  Future<void> download(int idx) async {
    String url = await this.getUrl(idx);
    String name = musicSto.songlist[idx].name;

    if (url.isEmpty) {
      musicSto.showSnacker('下载失败');
    } else {
      String savedDir = await Utils.downloadPath();
      String filename = Utils.formatFilename(name) + '.mp3';

      Directory dir = Directory(savedDir);
      if (!dir.existsSync()) {
        Directory(savedDir).createSync();
      }

      File mp3 = File(savedDir + '/' + filename);
      if (mp3.existsSync()) {
        musicSto.showSnacker('$name 文件已存在');
        return;
      }

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir,
        fileName: filename,
        showNotification: false,
        openFileFromNotification: false,
      );
      if (taskId.isNotEmpty) {
        musicSto.showSnacker('$name 下载成功');
        musicSto.refresh(() {
          musicSto.songlist[idx].isDownload = true;
        });
      }
    }
  }
}

final _Player player = new _Player();
