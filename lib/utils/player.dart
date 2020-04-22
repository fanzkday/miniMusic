import 'package:audioplayers/audioplayers.dart';
import 'package:miniMusic/pages/music/store.dart';

class _Player {
  bool get status {
    return this.audioPlayer.state == AudioPlayerState.PLAYING;
  }

  AudioPlayer audioPlayer = new AudioPlayer()..setVolume(1);

  _Player() {
    this.audioPlayer.onPlayerCompletion.listen((event) {
      this.next();
    });
  }

  Future<bool> play(int idx) async {
    this.audioPlayer.release();
    String url = await this.getUrl(idx);
    if (url.isNotEmpty) {
      int i = await this.audioPlayer.play(url);
      if (i == 1) {
        musicSto.playIndex = idx;
      }
    }
    return this.status;
  }

  Future<bool> pause() async {
    await this.audioPlayer.pause();
    return this.status;
  }

  Future<bool> resume() async {
    if (this.audioPlayer.state == null || this.audioPlayer.state == AudioPlayerState.STOPPED) {
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
    String url = await musicSto.getSongUrl(musicSto.songlist[idx]['id']);
    if (url.isEmpty) {
      musicSto.showSnacker('获取歌曲失败 | 版权原因不能播放');
      return '';
    }
    return url;
  }
}

final _Player player = new _Player();
