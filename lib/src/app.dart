import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:bootcamp_project/src/chats/ui/chats_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final List<Chat> chats;

  const App({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'RobotoC',
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
        ),
      ),
      home: ChatsPage(
        chats: chats,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
