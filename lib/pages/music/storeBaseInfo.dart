import 'package:audioplayers/audioplayers.dart';
import 'package:miniMusic/utils/store.dart';

class BaseInfoStore extends Store {
  String _username;
  String _password;

  int uid; // 用户的唯一标识id
  String avatar; // 用户头像地址

  List<Map> playlist = []; // 私人的歌单列表
  List<Map> songlist = []; // 歌单内的歌曲列表
  Map fmsong; // 私人fm歌曲信息

  double volume = 50; // 音量

  int _playIndex; // 当前播放歌曲的索引

  AudioPlayer audioPlayer = new AudioPlayer();

  set username(String value) {
    _username = value;
    this.storage.setString('username', value);
  }

  String get username {
    return this.storage.getString('username') ?? _username;
  }

  set password(String value) {
    _password = value;
    this.storage.setString('password', value);
  }

  String get password {
    return this.storage.getString('password') ?? _password;
  }

  set playIndex(int value) {
    _playIndex = value;
    this.storage.setInt('playIndex', value);
  }

  int get playIndex {
    return this.storage.getInt('playIndex') ?? _playIndex;
  }
}
