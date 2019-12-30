import 'package:miniMusic/pages/music/storeBaseInfo.dart';
import 'package:miniMusic/pages/music/typedefs.dart';
import 'package:miniMusic/utils/request.dart';
import 'package:miniMusic/utils/utils.dart';

class MusicStore extends BaseInfoStore {
  Future<String> login() async {
    if (uid != null) {
      return getPlaylist();
    }
    if (username != null && password != null) {
      var res = await request(
        url: '/login/cellphone?phone=$username&password=$password',
        method: 'get',
        isLogin: true,
      );
      if (res['code'] == 200) {
        uid = res['account']['id'];
        avatar = res['profile']['avatarUrl'];
        return getPlaylist();
      }
      return '登录失败';
    }
    return '输入账号密码';
  }

  // 获取歌单列表
  Future<String> getPlaylist() async {
    var res = await request(
      url: '/user/playlist?uid=$uid',
      method: 'get',
    );
    if (res['code'] == 200) {
      List list = res['playlist'];
      this.refresh(() {
        playlist = [];
        list.forEach((item) {
          playlist.add({'id': item['id'], 'name': item['name']});
        });
      });
      if (this.playlist.length > 0) {
        this.getSonglist(this.playlist[0]['id']);
      }
      return '';
    }
    return '获取歌单列表失败';
  }

  // 获取歌单中的歌曲列表
  Future<String> getSonglist(int id) async {
    var res = await request(
      url: '/playlist/detail?id=$id',
      method: 'get',
    );
    if (res['code'] == 200) {
      List list = res['playlist']['tracks'];
      this.refresh(() {
        songlist = [];
        list.forEach((item) {
          songlist.add(
            {'id': item['id'], 'name': item['name'], 'songer': item['ar'][0]['name'], 'duration': Utils.msToDt(item['dt'])},
          );
        });
      });
      return '';
    }
    return '获取歌曲列表失败';
  }

  // 获取歌单中的歌曲列表
  Future<String> getFMSonglist(Play play) async {
    if (fmsonglist.length > 0) {
      return '';
    }
    var res = await request(
      url: '/personal_fm',
      method: 'get',
    );
    if (res['code'] == 200) {
      List list = res['data'];
      this.refresh(() {
        fmsonglist = [];
        list.forEach((item) {
          fmsonglist.add(
            {'id': item['id'], 'name': item['name'], 'songer': item['artists'][0]['name'], 'duration': Utils.msToDt(item['duration'])},
          );
        });
      });
      play(null);
      return '';
    }
    return '获取私人FM歌曲失败';
  }

  // 收藏歌曲
  Future<String> trackSong(int playId, int songId) async {
    var res = await request(
      url: '/playlist/tracks?op=add\&pid=$playId\&tracks=$songId',
      method: 'get',
    );
    if (res['code'] == 200) {
      //
      return '收藏歌曲成功';
    }
    return '收藏歌曲失败';
  }

  // 根据歌曲id获取歌曲的url地址
  Future<String> getSongUrl(int id) async {
    var res = await request(
      url: '/song/url?id=$id',
      method: 'get',
    );
    if (res['code'] == 200) {
      var url = res['data'][0]['url'];
      if (url == null) {
        return '';
      }
      return url.replaceFirst(r'http://', 'https://');
    }
    return '';
  }
}

final MusicStore musicStore = new MusicStore();
