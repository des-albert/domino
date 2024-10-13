import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

double width = 0;
double height = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Domino Assistant',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(
              144, 224, 238, 0.25) // Set background color here
          ),
      home: const DominoForm(),
    );
  }
}

class Tile {
  String name;
  final int x;
  final int y;
  final int s;

  Tile(this.name, this.x, this.y, this.s);
}

class DominoForm extends StatefulWidget {
  const DominoForm({super.key});

  @override
  State<DominoForm> createState() => _DominoFormState();
}

class _DominoFormState extends State<DominoForm> {
  double iconWidth = width / 12.0;
  double iconHeight = width * 1.5 / 12.0;
  double boxWidth = 50.0;
  double boxHeight = 40.0;

  int testScore = 0;

  List<Tile> bones = [
    Tile('0-0', 0, 0, 0),
    Tile('1-0', 1, 0, 0),
    Tile('1-1', 1, 1, 2),
    Tile('2-0', 2, 0, 0),
    Tile('2-1', 2, 1, 0),
    Tile('2-2', 2, 2, 4),
    Tile('3-0', 3, 0, 0),
    Tile('3-1', 3, 1, 0),
    Tile('3-2', 3, 2, 0),
    Tile('3-3', 3, 3, 6),
    Tile('4-0', 4, 0, 0),
    Tile('4-1', 4, 1, 0),
    Tile('4-2', 4, 2, 0),
    Tile('4-3', 4, 3, 0),
    Tile('4-4', 4, 4, 8),
    Tile('5-0', 5, 0, 0),
    Tile('5-1', 5, 1, 0),
    Tile('5-2', 5, 2, 0),
    Tile('5-3', 5, 3, 0),
    Tile('5-4', 5, 4, 0),
    Tile('5-5', 5, 5, 10),
    Tile('6-0', 6, 0, 0),
    Tile('6-1', 6, 1, 0),
    Tile('6-2', 6, 2, 0),
    Tile('6-3', 6, 3, 0),
    Tile('6-4', 6, 4, 0),
    Tile('6-5', 6, 5, 0),
    Tile('6-6', 6, 6, 12),
    Tile('7-0', 7, 0, 0),
    Tile('7-1', 7, 1, 0),
    Tile('7-2', 7, 2, 0),
    Tile('7-3', 7, 3, 0),
    Tile('7-4', 7, 4, 0),
    Tile('7-5', 7, 5, 0),
    Tile('7-6', 7, 6, 0),
    Tile('7-7', 7, 7, 14),
    Tile('8-0', 8, 0, 0),
    Tile('8-1', 8, 1, 0),
    Tile('8-2', 8, 2, 0),
    Tile('8-3', 8, 3, 0),
    Tile('8-4', 8, 4, 0),
    Tile('8-5', 8, 5, 0),
    Tile('8-6', 8, 6, 0),
    Tile('8-7', 8, 7, 0),
    Tile('8-8', 8, 8, 16),
    Tile('9-0', 9, 0, 0),
    Tile('9-1', 9, 1, 0),
    Tile('9-2', 9, 2, 0),
    Tile('9-3', 9, 3, 0),
    Tile('9-4', 9, 4, 0),
    Tile('9-5', 9, 5, 0),
    Tile('9-6', 9, 6, 0),
    Tile('9-7', 9, 7, 0),
    Tile('9-8', 9, 8, 0),
    Tile('9-9', 9, 9, 18),
  ];

  List<Tile> table = [
    Tile('0', 0, 0, 0),
    Tile('1', 1, 0, 1),
    Tile('2', 2, 0, 2),
    Tile('3', 3, 0, 3),
    Tile('4', 4, 0, 4),
    Tile('5', 5, 0, 5),
    Tile('6', 6, 0, 6),
    Tile('7', 7, 0, 7),
    Tile('8', 8, 0, 8),
    Tile('9', 9, 0, 9),
    Tile('0-0', 0, 0, 0),
    Tile('1-1', 1, 1, 2),
    Tile('2-2', 2, 2, 4),
    Tile('3-3', 3, 3, 6),
    Tile('4-4', 4, 4, 8),
    Tile('5-5', 5, 5, 10),
    Tile('6-6', 6, 6, 12),
    Tile('7-7', 7, 7, 14),
    Tile('8-8', 8, 8, 16),
    Tile('9-9', 9, 9, 18),
  ];

  Tile? north, south, west, center, east;

  Tile result = Tile('', 0, 0, 0);
  int maxScore = 0;
  String matchString = "";
  List<Tile> matchList = [];
  List<Tile> tiles = [];
  int topLength = 0, bottomLength = 0;
  bool _visibleResults = false;

  void _addPile(Tile tile) {
    tiles.add(tile);
    if (tiles.length <= 11) {
      topLength = tiles.length;
      bottomLength = 0;
    } else {
      topLength = 11;
      bottomLength = tiles.length - 11;
    }
    setState(() {});
  }

  void _deletePile(Tile tile) {
    tiles.remove(tile);
    if (tiles.length <= 11) {
      topLength = tiles.length;
      bottomLength = 0;
    } else {
      topLength = 11;
      bottomLength = tiles.length - 11;
    }
    setState(() {});
  }

  void _addEndX(int t, Tile? p) {
    matchList.add(tiles[t]);
    if (tiles[t].s > 0) {
      testScore = tiles[t].s + p!.s;
    } else {
      testScore = tiles[t].x + p!.s;
    }
  }

  void _addEndY(int t, Tile? p) {
    matchList.add(tiles[t]);
    if (tiles[t].s > 0) {
      testScore = tiles[t].s + p!.s;
    } else {
      testScore = tiles[t].y + p!.s;
    }
  }

  void _addEndX2(int t, Tile? p, Tile? q) {
    matchList.add(tiles[t]);
    if (tiles[t].s > 0) {
      testScore = tiles[t].s + p!.s + q!.s;
    } else {
      testScore = tiles[t].x + p!.s + q!.s;
    }
  }

  void _addEndY2(int t, Tile? p, Tile? q) {
    matchList.add(tiles[t]);
    if (tiles[t].s > 0) {
      testScore = tiles[t].s + p!.s + q!.s;
    } else {
      testScore = tiles[t].y + p!.s + q!.s;
    }
  }

  void _addX2(int t, Tile? p, Tile? q) {
    matchList.add(tiles[t]);
    testScore = tiles[t].x + p!.s + q!.s;
  }

  void _addY2(int t, Tile? p, Tile? q) {
    matchList.add(tiles[t]);
    testScore = tiles[t].y + p!.s + q!.s;
  }

  void _addX3(int t, Tile? p, Tile? q, Tile? r) {
    matchList.add(tiles[t]);
    testScore = tiles[t].x + p!.s + q!.s + r!.s;
  }

  void _addY3(int t, Tile? p, Tile? q, Tile? r) {
    matchList.add(tiles[t]);
    testScore = tiles[t].y + p!.s + q!.s + r!.s;
  }

  void _addEndX3(int t, Tile? p, Tile? q, Tile? r) {
    matchList.add(tiles[t]);
    if (tiles[t].s > 0) {
      testScore = tiles[t].s + p!.s + q!.s + r!.s;
    } else {
      testScore = tiles[t].x + p!.s + q!.s + r!.s;
    }
  }

  void _addEndY3(int t, Tile? p, Tile? q, Tile? r) {
    matchList.add(tiles[t]);
    if (tiles[t].s > 0) {
      testScore = tiles[t].s + p!.s + q!.s + r!.s;
    } else {
      testScore = tiles[t].y + p!.s + q!.s + r!.s;
    }
  }

  void _solve() {
    result = Tile('', 0, 0, 0);
    maxScore = 0;
    matchList = [];

    if (center != null) {
      if (west == null && east == null && north == null && south == null) {
        // center

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].y + center!.s;
          } else if (tiles[t].y == center?.y) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + center!.s;
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east == null &&
          north == null &&
          south == null) {
        // center + west
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].y + west!.x;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + west!.x;
          } else if (tiles[t].x == west?.x) {
            _addEndY(t, center);
          } else if (tiles[t].y == west?.x) {
            _addEndX(t, center);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east != null &&
          north == null &&
          south == null) {
        // center + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = east!.x + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = east!.x + tiles[t].x;
          } else if (tiles[t].x == east?.x) {
            _addEndY(t, center);
          } else if (tiles[t].y == east?.x) {
            _addEndX(t, center);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east == null &&
          north != null &&
          south == null) {
        // center + north
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = north!.x + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = north!.x + tiles[t].x;
          } else if (tiles[t].x == north?.x) {
            _addEndY(t, center);
          } else if (tiles[t].y == north?.x) {
            _addEndX(t, center);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east == null &&
          north == null &&
          south != null) {
        // center + south

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = south!.x + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = south!.x + tiles[t].x;
          } else if (tiles[t].x == south?.x) {
            _addEndY(t, center);
          } else if (tiles[t].y == south?.x) {
            _addEndX(t, center);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east == null &&
          north != null &&
          south != null) {
        // center + north + south
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY2(t, north, south);
          } else if (tiles[t].y == center?.x) {
            _addX2(t, north, south);
          } else if (tiles[t].x == north?.x) {
            _addEndY(t, south);
          } else if (tiles[t].y == north?.x) {
            _addEndX(t, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY(t, north);
          } else if (tiles[t].y == south?.x) {
            _addEndX(t, north);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east != null &&
          north == null &&
          south == null) {
        // center + west + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY2(t, west, east);
          } else if (tiles[t].y == center?.x) {
            _addX2(t, west, east);
          } else if (tiles[t].x == west?.x) {
            _addEndY(t, east);
          } else if (tiles[t].y == west?.x) {
            _addEndX(t, east);
          } else if (tiles[t].x == east?.x) {
            _addEndY(t, west);
          } else if (tiles[t].y == east?.x) {
            _addEndX(t, west);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east == null &&
          north != null &&
          south == null) {
        // center + north + west
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY2(t, west, north);
          } else if (tiles[t].y == center?.x) {
            _addX2(t, west, north);
          } else if (tiles[t].x == west?.x) {
            _addEndY(t, north);
          } else if (tiles[t].y == west?.x) {
            _addEndX(t, north);
          } else if (tiles[t].x == north?.x) {
            _addEndY(t, west);
          } else if (tiles[t].y == north?.x) {
            _addEndX(t, west);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east != null &&
          north != null &&
          south == null) {
        // center + north + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY2(t, east, north);
          } else if (tiles[t].y == center?.x) {
            _addX2(t, east, north);
          } else if (tiles[t].x == east?.x) {
            _addEndY(t, north);
          } else if (tiles[t].y == east?.x) {
            _addEndX(t, north);
          } else if (tiles[t].x == north?.x) {
            _addEndY(t, east);
          } else if (tiles[t].y == north?.x) {
            _addEndX(t, east);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east == null &&
          north == null &&
          south != null) {
        // center + south + west
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY2(t, west, south);
          } else if (tiles[t].y == center?.x) {
            _addX2(t, west, south);
          } else if (tiles[t].x == west?.x) {
            _addEndY(t, south);
          } else if (tiles[t].y == west?.x) {
            _addEndX(t, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY(t, west);
          } else if (tiles[t].y == south?.x) {
            _addEndX(t, west);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east != null &&
          north == null &&
          south != null) {
        // center + south + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY2(t, east, south);
          } else if (tiles[t].y == center?.x) {
            _addX2(t, east, south);
          } else if (tiles[t].x == east?.x) {
            _addEndY(t, south);
          } else if (tiles[t].y == east?.x) {
            _addEndX(t, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY(t, east);
          } else if (tiles[t].y == south?.x) {
            _addEndX(t, east);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east == null &&
          north != null &&
          south != null) {
        // center + north + south + west

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY3(t, north, west, south);
          } else if (tiles[t].y == center?.x) {
            _addX3(t, north, west, south);
          } else if (tiles[t].x == north?.x) {
            _addEndY2(t, west, south);
          } else if (tiles[t].y == north?.x) {
            _addEndX2(t, west, south);
          } else if (tiles[t].x == west?.x) {
            _addEndY2(t, north, south);
          } else if (tiles[t].y == west?.x) {
            _addEndX2(t, north, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY2(t, north, west);
          } else if (tiles[t].y == south?.x) {
            _addEndX2(t, north, west);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west == null &&
          east != null &&
          north != null &&
          south != null) {
        // center + north + south + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY3(t, north, east, south);
          } else if (tiles[t].y == center?.x) {
            _addX3(t, north, east, south);
          } else if (tiles[t].x == north?.x) {
            _addEndY2(t, east, south);
          } else if (tiles[t].y == north?.x) {
            _addEndX2(t, east, south);
          } else if (tiles[t].x == east?.x) {
            _addEndY2(t, north, south);
          } else if (tiles[t].y == east?.x) {
            _addEndX2(t, north, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY2(t, north, east);
          } else if (tiles[t].y == south?.x) {
            _addEndX2(t, north, east);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east != null &&
          north == null &&
          south != null) {
        // center + west + south + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY3(t, east, west, south);
          } else if (tiles[t].y == center?.x) {
            _addX3(t, east, west, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY2(t, east, west);
          } else if (tiles[t].y == south?.x) {
            _addEndX2(t, east, west);
          } else if (tiles[t].x == east?.x) {
            _addEndY2(t, south, west);
          } else if (tiles[t].y == east?.x) {
            _addEndX2(t, south, west);
          } else if (tiles[t].x == west?.x) {
            _addEndY2(t, south, east);
          } else if (tiles[t].y == west?.x) {
            _addEndX2(t, south, east);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east != null &&
          north != null &&
          south == null) {
        // center + west + north + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            _addY3(t, east, west, north);
          } else if (tiles[t].y == center?.x) {
            _addX3(t, east, west, north);
          } else if (tiles[t].x == north?.x) {
            _addEndY2(t, east, west);
          } else if (tiles[t].y == north?.x) {
            _addEndX2(t, east, west);
          } else if (tiles[t].x == west?.x) {
            _addEndY2(t, east, north);
          } else if (tiles[t].y == west?.x) {
            _addEndX2(t, east, north);
          } else if (tiles[t].x == east?.x) {
            _addEndY2(t, west, north);
          } else if (tiles[t].y == east?.x) {
            _addEndX2(t, west, north);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (west != null &&
          east != null &&
          north != null &&
          south != null) {
        // center + north + south + west + east
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == west?.x) {
            _addEndY3(t, north, east, south);
          } else if (tiles[t].y == west?.x) {
            _addEndX3(t, north, east, south);
          } else if (tiles[t].x == north?.x) {
            _addEndY3(t, west, east, south);
          } else if (tiles[t].y == north?.x) {
            _addEndX3(t, west, east, south);
          } else if (tiles[t].x == east?.x) {
            _addEndY3(t, north, west, south);
          } else if (tiles[t].y == east?.x) {
            _addEndX3(t, north, west, south);
          } else if (tiles[t].x == south?.x) {
            _addEndY3(t, north, east, west);
          } else if (tiles[t].y == south?.x) {
            _addEndX3(t, north, east, west);
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      }
    }
    matchString = '';
    if (matchList.isNotEmpty) {
      for (Tile k in matchList) {
        matchString += '${k.name} ';
      }
    }
    _visibleResults = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('DB\'r Domino Solver'),
          foregroundColor: Colors.lightBlueAccent,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(14, 110, 140, 0.5)),
      body: Column(children: [
        const Divider(
          height: 10,
          thickness: 0,
          indent: 5,
          endIndent: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (index) {
            return Container(
              padding: const EdgeInsets.all(0.0),
              width: iconWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset("assets/${bones[index].name}.png",
                    height: iconHeight, width: iconWidth),
                onPressed: () async {
                  _addPile(bones[index]);
                },
              ),
            );
          }),
        ),
        const Divider(
          color: Colors.blue,
          height: 5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (index) {
            return Container(
              padding: const EdgeInsets.all(0.0),
              width: iconWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset("assets/${bones[index + 11].name}.png",
                    height: iconHeight, width: iconWidth),
                onPressed: () async {
                  _addPile(bones[index + 11]);
                },
              ),
            );
          }),
        ),
        const Divider(
          color: Colors.blue,
          height: 5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (index) {
            return Container(
              padding: const EdgeInsets.all(0.0),
              width: iconWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset("assets/${bones[index + 22].name}.png",
                    height: iconHeight, width: iconWidth),
                onPressed: () async {
                  _addPile(bones[index + 22]);
                },
              ),
            );
          }),
        ),
        const Divider(
          color: Colors.blue,
          height: 5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (index) {
            return Container(
              padding: const EdgeInsets.all(0.0),
              width: iconWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset("assets/${bones[index + 33].name}.png",
                    height: iconHeight, width: iconWidth),
                onPressed: () async {
                  _addPile(bones[index + 33]);
                },
              ),
            );
          }),
        ),
        const Divider(
          color: Colors.blue,
          height: 5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (index) {
            return Container(
              padding: const EdgeInsets.all(0.0),
              width: iconWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset("assets/${bones[index + 44].name}.png",
                    height: iconHeight, width: iconWidth),
                onPressed: () async {
                  _addPile(bones[index + 44]);
                },
              ),
            );
          }),
        ),
        const Divider(
          color: Colors.blue,
          height: 5,
          thickness: 2,
          indent: 5,
          endIndent: 5,
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: () async {
            _solve();
          },
          child: const Text('Solve'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(topLength, (inx) {
            return Container(
                padding: const EdgeInsets.all(0.0),
                width: iconWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Image.asset("assets/${tiles[inx].name}.png",
                      height: iconHeight, width: iconWidth),
                  onPressed: () {
                    _deletePile(tiles[inx]);
                  },
                ));
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bottomLength, (inx) {
            return Container(
                padding: const EdgeInsets.all(0.0),
                width: iconWidth,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Image.asset("assets/${tiles[inx + 11].name}.png",
                      height: iconHeight, width: iconWidth),
                  onPressed: () {
                    _deletePile(tiles[inx]);
                  },
                ));
          }),
        ),
        const Divider(
          color: Colors.blue,
          height: 5,
          thickness: 0,
          indent: 5,
          endIndent: 5,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Tile>(
                  value: north,
                  iconSize: 0,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.yellow),
                  dropdownColor: Colors.blue,
                  items: table.map((Tile val) {
                    return DropdownMenuItem<Tile>(
                      value: val,
                      child: Center(child: Text(val.name)),
                    );
                  }).toList(),
                  onChanged: (Tile? newValue) {
                    setState(() {
                      north = newValue!;
                    });
                  },
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Tile>(
                    value: west,
                    iconSize: 0,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.yellow),
                    dropdownColor: Colors.blue,
                    items: table.map((Tile val) {
                      return DropdownMenuItem<Tile>(
                        value: val,
                        child: Center(child: Text(val.name)),
                      );
                    }).toList(),
                    onChanged: (Tile? newValue) {
                      setState(() {
                        west = newValue!;
                      });
                    }),
              ),
            ),
            Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Tile>(
                    value: center,
                    iconSize: 0,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.yellow),
                    dropdownColor: Colors.blue,
                    items: table.map((Tile val) {
                      return DropdownMenuItem<Tile>(
                        value: val,
                        child: Center(child: Text(val.name)),
                      );
                    }).toList(),
                    onChanged: (Tile? newValue) {
                      setState(() {
                        center = newValue!;
                      });
                    }),
              ),
            ),
            Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Tile>(
                    value: east,
                    iconSize: 0,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.yellow),
                    dropdownColor: Colors.blue,
                    items: table.map((Tile val) {
                      return DropdownMenuItem<Tile>(
                        value: val,
                        child: Center(child: Text(val.name)),
                      );
                    }).toList(),
                    onChanged: (Tile? newValue) {
                      setState(() {
                        east = newValue!;
                      });
                    }),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Tile>(
                    value: south,
                    iconSize: 0,
                    isExpanded: true,
                    style: const TextStyle(color: Colors.yellow),
                    dropdownColor: Colors.blue,
                    items: table.map((Tile val) {
                      return DropdownMenuItem<Tile>(
                        value: val,
                        child: Center(child: Text(val.name)),
                      );
                    }).toList(),
                    onChanged: (Tile? newValue) {
                      setState(() {
                        south = newValue!;
                      });
                    }),
              ),
            )
          ],
        ),
        Visibility(
          visible: _visibleResults,
          child: Column(
            children: [
              const Divider(
                color: Colors.blue,
                height: 5,
                thickness: 0,
                indent: 5,
                endIndent: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(matchList.length, (index) {
                  return Center(
                    child: SizedBox (
                        width: iconWidth,
                        height: iconHeight,
                        child: Image.asset(
                            'assets/${matchList[index].name}.png',
                            fit: BoxFit.contain)),
                  );
                }),
              ),
              Text(
                style: const TextStyle(fontSize: 20, color: Colors.green),
                ' Score $maxScore ',
              ),
              Center(
                child: result.name != ''
                    ? SizedBox(
                        width: iconWidth,
                        height: iconHeight,
                        child: Image.asset('assets/${result.name}.png',
                            fit: BoxFit.contain))
                    : const Text(
                        style: TextStyle(fontSize: 20, color: Colors.green),
                        ' No Scoring moves ',
                      ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
