import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Domino Assistant',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(
              144, 224, 238, 0.22745098039215686) // Set background color here
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
  double iconHeight = 60.0;
  double iconWidth = 35.0;
  double boxWidth = 40.0;
  double boxHeight = 40.0;

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

  void _solve() {
    int testScore = 0;
    result = Tile('', 0, 0, 0);
    maxScore = 0;
    matchList = [];

    if (center != null) {
      if (west == null && east == null && north == null && south == null) {
        // center

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = center!.s + tiles[t].y;
          } else if (tiles[t].y == center?.y) {
            matchList.add(tiles[t]);
            testScore = center!.s + tiles[t].x;
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
            testScore = west!.x + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = west!.x + tiles[t].x;
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].y + center!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].x + center!.s;
            }
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
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].y + center!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].x + center!.s;
            }
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
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].y + center!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].x + center!.s;
            }
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
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].y + center!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].x + center!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = north!.s + south!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = north!.s + south!.s + tiles[t].x;
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s;
            } else {
              testScore = tiles[t].y + south!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s;
            } else {
              testScore = tiles[t].x + south!.s;
            }
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s;
            } else {
              testScore = tiles[t].y + north!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s;
            } else {
              testScore = tiles[t].x + north!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = west!.s + east!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = west!.s + east!.s + tiles[t].x;
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s;
            } else {
              testScore = tiles[t].y + east!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s;
            } else {
              testScore = tiles[t].x + east!.s;
            }
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s;
            } else {
              testScore = tiles[t].y + west!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s;
            } else {
              testScore = tiles[t].x + west!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = west!.s + north!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = west!.s + north!.s + tiles[t].x;
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s;
            } else {
              testScore = tiles[t].y + north!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s;
            } else {
              testScore = tiles[t].x + north!.s;
            }
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s;
            } else {
              testScore = tiles[t].y + west!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s;
            } else {
              testScore = tiles[t].x + west!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = east!.s + north!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = east!.s + north!.s + tiles[t].x;
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s;
            } else {
              testScore = tiles[t].y + north!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s;
            } else {
              testScore = tiles[t].x + north!.s;
            }
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s;
            } else {
              testScore = tiles[t].y + east!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s;
            } else {
              testScore = tiles[t].x + east!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = west!.s + south!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = west!.s + south!.s + tiles[t].x;
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s;
            } else {
              testScore = tiles[t].y + south!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s;
            } else {
              testScore = tiles[t].x + south!.s;
            }
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s;
            } else {
              testScore = tiles[t].y + west!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s;
            } else {
              testScore = tiles[t].x + west!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = east!.s + south!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = east!.s + south!.s + tiles[t].x;
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s;
            } else {
              testScore = tiles[t].y + south!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s;
            } else {
              testScore = tiles[t].x + south!.s;
            }
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s;
            } else {
              testScore = tiles[t].y + east!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s;
            } else {
              testScore = tiles[t].x + east!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = tiles[t].y + north!.s + west!.s + south!.s;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + north!.s + west!.s + south!.s;
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + south!.s;
            } else {
              testScore = tiles[t].y + west!.s + south!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + south!.s;
            } else {
              testScore = tiles[t].x + west!.s + south!.s;
            }
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + south!.s;
            } else {
              testScore = tiles[t].y + north!.s + south!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + south!.s;
            } else {
              testScore = tiles[t].x + north!.s + south!.s;
            }
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + west!.s;
            } else {
              testScore = tiles[t].y + north!.s + west!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + west!.s;
            } else {
              testScore = tiles[t].x + north!.s + west!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = tiles[t].y + north!.s + east!.s + south!.s;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + north!.s + east!.s + south!.s;
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + south!.s;
            } else {
              testScore = tiles[t].y + east!.s + south!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + south!.s;
            } else {
              testScore = tiles[t].x + east!.s + south!.s;
            }
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + south!.s;
            } else {
              testScore = tiles[t].y + north!.s + south!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + south!.s;
            } else {
              testScore = tiles[t].x + north!.s + south!.s;
            }
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + east!.s;
            } else {
              testScore = tiles[t].y + north!.s + east!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + east!.s;
            } else {
              testScore = tiles[t].x + north!.s + east!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = tiles[t].y + west!.s + east!.s + south!.s;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + west!.s + east!.s + south!.s;
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + west!.s;
            } else {
              testScore = tiles[t].y + east!.s + west!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + west!.s;
            } else {
              testScore = tiles[t].x + east!.s + west!.s;
            }
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + south!.s;
            } else {
              testScore = tiles[t].y + west!.s + south!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + south!.s;
            } else {
              testScore = tiles[t].x + west!.s + south!.s;
            }
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + south!.s + east!.s;
            } else {
              testScore = tiles[t].y + south!.s + east!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + south!.s;
            } else {
              testScore = tiles[t].x + west!.s + south!.s;
            }
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
            matchList.add(tiles[t]);
            testScore = tiles[t].y + west!.s + east!.s + north!.s;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + west!.s + east!.s + north!.s;
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + west!.s;
            } else {
              testScore = tiles[t].y + east!.s + west!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + west!.s;
            } else {
              testScore = tiles[t].x + east!.s + west!.s;
            }
          } else if (tiles[t].x == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + east!.s + north!.s;
            } else {
              testScore = tiles[t].y + east!.s + north!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + north!.s;
            } else {
              testScore = tiles[t].x + west!.s + north!.s;
            }
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + north!.s;
            } else {
              testScore = tiles[t].y + west!.s + north!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + north!.s;
            } else {
              testScore = tiles[t].x + west!.s + north!.s;
            }
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
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + east!.s + south!.s;
            } else {
              testScore = tiles[t].y + north!.s + east!.s + south!.s;
            }
          } else if (tiles[t].y == west?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + east!.s + south!.s;
            } else {
              testScore = tiles[t].x + north!.s + east!.s + south!.s;
            }
          } else if (tiles[t].x == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + east!.s + south!.s;
            } else {
              testScore = tiles[t].y + west!.s + east!.s + south!.s;
            }
          } else if (tiles[t].y == north?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + west!.s + east!.s + south!.s;
            } else {
              testScore = tiles[t].x + west!.s + east!.s + south!.s;
            }
          } else if (tiles[t].x == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + west!.s + south!.s;
            } else {
              testScore = tiles[t].y + north!.s + west!.s + south!.s;
            }
          } else if (tiles[t].y == east?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + west!.s + south!.s;
            } else {
              testScore = tiles[t].x + north!.s + west!.s + south!.s;
            }
          } else if (tiles[t].x == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + east!.s + west!.s;
            } else {
              testScore = tiles[t].y + north!.s + east!.s + west!.s;
            }
          } else if (tiles[t].y == south?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + north!.s + east!.s + west!.s;
            } else {
              testScore = tiles[t].x + north!.s + east!.s + west!.s;
            }
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
          backgroundColor:
              const Color.fromRGBO(14, 110, 140, 0.5333333333333333)),
      body: Column(children: [
        const Divider(
          height: 20,
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
          color: Colors.red,
          height: 10,
          thickness: 2,
          indent: 20,
          endIndent: 20,
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
        const Divider(
          color: Colors.red,
          height: 20,
          thickness: 2,
          indent: 20,
          endIndent: 20,
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
              const Text(
                style: TextStyle(fontSize: 20, color: Colors.green),
                ' Matches ',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(matchList.length, (index) {
                  return Center(
                    child: SizedBox(
                        width: iconWidth,
                        height: iconHeight,
                        child: Image.asset(
                            'assets/${matchList[index].name}.png',
                            fit: BoxFit.cover)),
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
                            fit: BoxFit.cover))
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
