import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataWrapper {
  final String jsonPath;
  late List<PageContent> content;

  DataWrapper(this.jsonPath);

  Future<List<Widget>> getPages() async {
    var jsonString = await rootBundle.loadString(jsonPath);

    var json = jsonDecode(jsonString);
    content = [];

    for (var p in json['set']) {
      content.add(PageContent(p['title'], p['description'], p['image']));
    }

    List<Widget> ps = [];
    ps.add(TitlePage(content.first.title, content.first.description,
        image: content.first.image));
    for (var i = 1; i < content.length; i++) {
      ps.add(CoffeePage(content[i].title, content[i].description,
          image: content[i].image));
    }
    return ps;
  }
}

class PageContent {
  final String title;
  final String description;
  final String? image;

  PageContent(this.title, this.description, this.image);
}

class TitlePage extends StatelessWidget {
  final String title;
  final String description;
  final String? image;
  const TitlePage(
    this.title,
    this.description, {
    Key? key,
    this.image,
  }) : super(key: key);

  static const manual = 'РУКОВОДСТВО\nПО ПРИГОТОВЛЕНИЮ';

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          if (image == null)
            const Placeholder()
          else
            Positioned.fill(
              child: Image.asset(
                'assets/${image!}',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.65),
              ),
            ),
          Column(
            children: [
              const Expanded(flex: 1, child: SizedBox.expand()),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              title.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Text(
                              manual,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class CoffeePage extends StatelessWidget {
  final String title;
  final String description;
  final String? image;
  const CoffeePage(this.title, this.description, {Key? key, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget pic;
    if (image == null) {
      pic = const Placeholder();
    } else {
      pic = Image.asset(
        'assets/${image!}',
        fit: BoxFit.cover,
      );
    }

    return Stack(children: [
      Positioned.fill(child: pic),
      Column(
        children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
            child: Container(
              color: const Color.fromARGB(128, 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Row(
                        children: [
                          Text(
                            title.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        description,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
