import 'package:coffee/data_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      home: const CoffeePages(),
    );
  }
}

class CoffeePages extends StatefulWidget {
  const CoffeePages({Key? key}) : super(key: key);

  @override
  State<CoffeePages> createState() => _CoffeePagesState();
}

class _CoffeePagesState extends State<CoffeePages> {
  late List<Widget> pages = [];
  final controller = PageController();
  String title = 'Кемекс';
  Map<double, String> titles = {0: 'Кемекс', 6: 'Френч-пресс'};
  @override
  void initState() {
    loadData();
    controller.addListener(
      () => getTitle(controller.page ?? 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[700],
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.brown[700],
                ),
                child: const Text(
                  'Способы заваривания',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                )),
            for (var t in titles.entries)
              ListTile(
                title: Text(
                  t.value,
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    controller.animateToPage(t.key.toInt(),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  });
                },
              )
          ],
        ),
      ),
      body: PageView(
        allowImplicitScrolling: true,
        controller: controller,
        children: pages,
      ),
    );
  }

  void getTitle(double page) {
    for (int i = titles.length - 1; i >= 0; i--) {
      if (page >= titles.keys.elementAt(i)) {
        setState(() {
          title = titles.entries.elementAt(i).value;
        });
        break;
      }
    }
  }

  void loadData() {
    void _load(String p) {
      DataWrapper('data/$p').getPages().then((value) => setState(() {
            pages += value;
          }));
    }

    _load('chemex.json');
    _load('frenchpress.json');
  }
}
