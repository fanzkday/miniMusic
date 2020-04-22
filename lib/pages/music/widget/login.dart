import 'package:flutter/material.dart';
import 'package:miniMusic/pages/music/store.dart';

class Login extends StatelessWidget {
  final nameController = new TextEditingController(text: musicSto.storage.getString('username'));
  final pwdController = new TextEditingController(text: musicSto.storage.getString('password'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Wrap(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: '用户名',
              hasFloatingPlaceholder: false,
              isDense: true,
            ),
            controller: nameController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              musicSto.username = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: '密码',
              hasFloatingPlaceholder: false,
              isDense: true,
            ),
            controller: pwdController,
            obscureText: true,
            onChanged: (String value) {
              musicSto.password = value;
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async {
                    var errMsg = await musicSto.login();
                    musicSto.showSnacker(errMsg);
                  },
                  child: Text('登录'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
