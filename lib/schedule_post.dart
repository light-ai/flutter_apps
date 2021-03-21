import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/time_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SchedulePost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SchedulePostState();
  }
}

class _SchedulePostState extends State<SchedulePost> {
  var _labelText = 'Select Date';
  final _controller = TimePickerController();
  String messageText = '';

  void resetTime() {
    // [TimePickerController]に対して`DateTime`を設定するだけです。
    _controller.setTime(DateTime.now());
  }

  void printTime() {
    // 値の取得も[TimePickerController]経由で`hour`/`minute`でアクセスできます。
    print('time = ${_controller.hour} : ${_controller.minute}');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (selected != null) {
      setState(() {
        _labelText = (DateFormat.yMMMd()).format(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('スケジュール選択'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                _labelText,
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () => _selectDate(context),
              ),
              TimePicker(controller: _controller),
              TextFormField(
                decoration: InputDecoration(labelText: 'スケジュール管理メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('保存'),
                  onPressed: () async {
                    final date =
                    DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = currentUser.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await Firestore.instance
                        .collection('users') // コレクションID指定
                        .doc(currentUser.uid)
                        .collection('schedule')
                        .doc()
                        .set({
                      'text': messageText,
                      'year': _labelText,
                      'day': "${_controller.hour} : ${_controller.minute}",
                      'date': date,
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}