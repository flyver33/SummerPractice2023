import 'dart:convert';

import 'package:bootcamp_project/src/app.dart';
import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final chats = await _loadChatList();

  runApp(App(chats: chats));
}

Future<List<Chat>> _loadChatList() async {
  final result = <Chat>[];
  var rawData =
      jsonDecode(await rootBundle.loadString('assets/data/bootcamp.json'));
  var dataList = rawData['data'];
  dataList.removeWhere((item) => item['lastMessage'] == null);
  dataList.sort((a, b) => DateTime.fromMillisecondsSinceEpoch(b['date'])
      .compareTo(DateTime.fromMillisecondsSinceEpoch(a['date'])));
  for (final item in dataList) {
    result.add(Chat.fromJson(item));
  }
  return result;
}
