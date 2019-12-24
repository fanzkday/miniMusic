import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ShowSnacker = void Function(String msg);

class Store {
  static Map<int, State> _states = {};
  static SharedPreferences _preferences;

  // 负责初始化异步的连接, runApp内同步初始化
  static Future<void> init() async {
    Store._preferences = await SharedPreferences.getInstance();
  }

  ShowSnacker showSnacker;

  SharedPreferences get storage => Store._preferences;

  void bind(State state) {
    Store._states.update(state.hashCode, (s) => state, ifAbsent: () => state);

    Store._states.removeWhere((idx, state) {
      return !state.mounted;
    });
  }

  void refresh(Function callBack) async {
    await callBack();
    Store._states.forEach((key, State state) {
      if (state.mounted) {
        // ignore: invalid_use_of_protected_member
        state.setState(() {});
      }
    });
  }
}
