import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

bool isSameWeek(DateTime? dateA, DateTime? dateB) {
  return dateB!.difference(dateA!).inDays < 7;
}

class ChatsPage extends StatelessWidget {
  final List<Chat> chats;

  const ChatsPage({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru', null);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Telegram'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchPage(chats: chats))),
            ),
          ],
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 24.0,
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              );
            },
          ),
          backgroundColor: const Color.fromARGB(255, 36, 45, 57),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 19,
            letterSpacing: 0.4,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 29, 39, 51),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: ListView.separated(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return tiles(chats[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 20,
                thickness: 0.4,
                indent: 80,
                endIndent: 0,
                color: Colors.black,
              );
            },
          ),
        ));
  }
}

class SearchPage extends StatefulWidget {
  final List<Chat> chats;

  const SearchPage({super.key, required this.chats});

  @override
  // ignore: no_logic_in_create_state
  State<SearchPage> createState() => SearchPageState(chats: chats);
}

class SearchPageState extends State<SearchPage> {
  SearchPageState({required this.chats});

  List<Chat> chats;

  List<Chat> foundChats = [];

  @override
  initState() {
    foundChats = chats;
    super.initState();
  }

  void runFilter(String enteredKeyword) {
    List<Chat> results = [];
    if (enteredKeyword.isEmpty) {
      results = chats;
    } else {
      results = chats
              .where((chat) => chat.userName
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList() +
          chats
              .where((chat) => chat.lastMessage!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
    }

    setState(() {
      foundChats = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru', null);
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 250,
            child: TextField(
              onChanged: (value) => runFilter(value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 125, 139, 153),
                ),
                hintText: 'Поиск',
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 24.0,
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatsPage(chats: chats)),
                  );
                },
              );
            },
          ),
          backgroundColor: const Color.fromARGB(255, 36, 45, 57),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 19,
            letterSpacing: 0.4,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 29, 39, 51),
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: foundChats.isNotEmpty
                ? ListView.separated(
                    itemCount: foundChats.length,
                    itemBuilder: (context, index) {
                      return tiles(foundChats[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 20,
                        thickness: 0.4,
                        indent: 80,
                        endIndent: 0,
                        color: Colors.black,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                    'Чаты не найдены',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 125, 139, 153),
                    ),
                    textAlign: TextAlign.center,
                  ))));
  }
}

Widget tiles(Chat chats) {
  return ListTile(
    leading: Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [
            lighten(chats.userColor!, .15),
            chats.userColor!,
          ], stops: const [
            0.0,
            0.7
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: CircleAvatar(
        radius: 24,
        foregroundImage: AssetImage(chats.userAvatar ?? ''),
        backgroundColor: Colors.transparent,
        child: Text(
          chats.userName[0],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    ),
    title: Row(children: <Widget>[
      Expanded(
          child: Text(
        chats.userName,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 17,
          letterSpacing: 0.5,
        ),
      )),
      Expanded(
          child: Text(
        DateUtils.isSameDay(chats.date, DateTime.now())
            ? DateFormat.Hm().format(chats.date!).toString()
            : isSameWeek(chats.date, DateTime.now())
                ? DateFormat('E', 'ru').format(chats.date!).toString()
                : DateFormat('d MMM', 'ru').format(chats.date!).toString(),
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 115, 127, 139),
          fontSize: 14,
          letterSpacing: 0.4,
        ),
      )),
    ]),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(children: <Widget>[
        Expanded(
            child: Text(
          chats.lastMessage.toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            color: Color.fromARGB(255, 125, 139, 153),
            fontSize: 15,
            letterSpacing: 0.4,
          ),
        )),
        chats.countUnreadMessages > 0
            ? Center(
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 62, 82, 99),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.fromLTRB(7.5, 4, 7.5, 4),
                    child: Center(
                        child: Text(
                      chats.countUnreadMessages.toString(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.4,
                      ),
                    ))))
            : Center(
                child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 29, 39, 51),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(7.5, 4, 7.5, 4),
              ))
      ]),
    ),
  );
}
