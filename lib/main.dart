import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Domino Assistant',
      home: DominoForm(),
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
  double boxHeight = 30.0;

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
    Tile('9-9', 9, 9, 18),
    Tile('8-8', 8, 8, 16)
  ];

  Tile? upper, lower, left, center, right;

  Tile result = Tile('', 0, 0, 0);
  int maxScore = 0;
  String matchString = "";
  List<Tile> matchList = [];

  List<Tile> tiles = [];

  void _addPile(Tile tile) {
    tiles.add(tile);
    setState(() {});
  }

  void _deletePile(Tile tile) {
    tiles.remove(tile);
    setState(() {});
  }

  void _solve() {
    int testScore = 0;
    result = Tile('', 0, 0, 0);
    maxScore = 0;
    matchList = [];

    if (center != null) {
      if (left == null && right == null && upper == null && lower == null) {
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
      } else if (left == null &&
          right == null &&
          upper != null &&
          lower == null) {
        // center + upper

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = upper!.x + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = upper!.x + tiles[t].x;
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].y + center!.s;
            }
          } else if (tiles[t].y == upper?.x) {
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
      } else if (left == null &&
          right == null &&
          upper == null &&
          lower != null) {
        // center + lower

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = lower!.x + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = lower!.x + tiles[t].x;
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + center!.s;
            } else {
              testScore = tiles[t].y + center!.s;
            }
          } else if (tiles[t].y == lower?.x) {
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
      } else if (left == null &&
          right == null &&
          upper != null &&
          lower != null) {
        // center + upper + lower
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = upper!.s + lower!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = upper!.s + lower!.s + tiles[t].x;
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + lower!.s;
            } else {
              testScore = tiles[t].y + lower!.s;
            }
          } else if (tiles[t].y == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + lower!.s;
            } else {
              testScore = tiles[t].x + lower!.s;
            }
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s;
            } else {
              testScore = tiles[t].y + upper!.s;
            }
          } else if (tiles[t].y == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s;
            } else {
              testScore = tiles[t].x + upper!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left != null &&
          right != null &&
          upper == null &&
          lower == null) {
        // center + left + right
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = left!.s + right!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = left!.s + right!.s + tiles[t].x;
          } else if (tiles[t].x == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s;
            } else {
              testScore = tiles[t].y + right!.s;
            }
          } else if (tiles[t].y == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s;
            } else {
              testScore = tiles[t].x + right!.s;
            }
          } else if (tiles[t].x == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s;
            } else {
              testScore = tiles[t].y + left!.s;
            }
          } else if (tiles[t].y == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s;
            } else {
              testScore = tiles[t].x + left!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left != null &&
          right == null &&
          upper != null &&
          lower == null) {
        // center + upper + left
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = left!.s + upper!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = left!.s + upper!.s + tiles[t].x;
          } else if (tiles[t].x == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s;
            } else {
              testScore = tiles[t].y + upper!.s;
            }
          } else if (tiles[t].y == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s;
            } else {
              testScore = tiles[t].x + upper!.s;
            }
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s;
            } else {
              testScore = tiles[t].y + left!.s;
            }
          } else if (tiles[t].y == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s;
            } else {
              testScore = tiles[t].x + left!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left == null &&
          right != null &&
          upper != null &&
          lower == null) {
        // center + upper + right
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = right!.s + upper!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = right!.s + upper!.s + tiles[t].x;
          } else if (tiles[t].x == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s;
            } else {
              testScore = tiles[t].y + upper!.s;
            }
          } else if (tiles[t].y == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s;
            } else {
              testScore = tiles[t].x + upper!.s;
            }
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s;
            } else {
              testScore = tiles[t].y + right!.s;
            }
          } else if (tiles[t].y == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s;
            } else {
              testScore = tiles[t].x + right!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left != null &&
          right == null &&
          upper == null &&
          lower != null) {
        // center + lower + left
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = left!.s + lower!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = left!.s + lower!.s + tiles[t].x;
          } else if (tiles[t].x == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + lower!.s;
            } else {
              testScore = tiles[t].y + lower!.s;
            }
          } else if (tiles[t].y == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + lower!.s;
            } else {
              testScore = tiles[t].x + lower!.s;
            }
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s;
            } else {
              testScore = tiles[t].y + left!.s;
            }
          } else if (tiles[t].y == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s;
            } else {
              testScore = tiles[t].x + left!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left == null &&
          right != null &&
          upper == null &&
          lower != null) {
        // center + lower + right
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = right!.s + lower!.s + tiles[t].y;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = right!.s + lower!.s + tiles[t].x;
          } else if (tiles[t].x == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + lower!.s;
            } else {
              testScore = tiles[t].y + lower!.s;
            }
          } else if (tiles[t].y == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + lower!.s;
            } else {
              testScore = tiles[t].x + lower!.s;
            }
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s;
            } else {
              testScore = tiles[t].y + right!.s;
            }
          } else if (tiles[t].y == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s;
            } else {
              testScore = tiles[t].x + right!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left != null &&
          right == null &&
          upper != null &&
          lower != null) {
        // center + upper + lower + left

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].y + upper!.s + left!.s + lower!.s;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + upper!.s + left!.s + lower!.s;
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s + lower!.s;
            } else {
              testScore = tiles[t].y + left!.s + lower!.s;
            }
          } else if (tiles[t].y == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s + lower!.s;
            } else {
              testScore = tiles[t].x + left!.s + lower!.s;
            }
          } else if (tiles[t].x == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + lower!.s;
            } else {
              testScore = tiles[t].y + upper!.s + lower!.s;
            }
          } else if (tiles[t].y == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + lower!.s;
            } else {
              testScore = tiles[t].x + upper!.s + lower!.s;
            }
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + left!.s;
            } else {
              testScore = tiles[t].y + upper!.s + left!.s;
            }
          } else if (tiles[t].y == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + left!.s;
            } else {
              testScore = tiles[t].x + upper!.s + left!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left == null &&
          right != null &&
          upper != null &&
          lower != null) {
        // center + upper + lower + right

        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].y + upper!.s + right!.s + lower!.s;
          } else if (tiles[t].y == center?.x) {
            matchList.add(tiles[t]);
            testScore = tiles[t].x + upper!.s + right!.s + lower!.s;
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s + lower!.s;
            } else {
              testScore = tiles[t].y + right!.s + lower!.s;
            }
          } else if (tiles[t].y == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + right!.s + lower!.s;
            } else {
              testScore = tiles[t].x + right!.s + lower!.s;
            }
          } else if (tiles[t].x == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + lower!.s;
            } else {
              testScore = tiles[t].y + upper!.s + lower!.s;
            }
          } else if (tiles[t].y == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + lower!.s;
            } else {
              testScore = tiles[t].x + upper!.s + lower!.s;
            }
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + right!.s;
            } else {
              testScore = tiles[t].y + upper!.s + right!.s;
            }
          } else if (tiles[t].y == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + right!.s;
            } else {
              testScore = tiles[t].x + upper!.s + right!.s;
            }
          }
          if (testScore % 5 == 0 && testScore > maxScore) {
            maxScore = testScore;
            result = tiles[t];
          }
        }
      } else if (left != null &&
          right != null &&
          upper != null &&
          lower != null) {
        // center + upper + lower + left + right
        for (int t = 0; t < tiles.length; t++) {
          if (tiles[t].x == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + right!.s + lower!.s;
            } else {
              testScore = tiles[t].y + upper!.s + right!.s + lower!.s;
            }
          } else if (tiles[t].y == left?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + right!.s + lower!.s;
            } else {
              testScore = tiles[t].x + upper!.s + right!.s + lower!.s;
            }
          } else if (tiles[t].x == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s + right!.s + lower!.s;
            } else {
              testScore = tiles[t].y + left!.s + right!.s + lower!.s;
            }
          } else if (tiles[t].y == upper?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + left!.s + right!.s + lower!.s;
            } else {
              testScore = tiles[t].x + left!.s + right!.s + lower!.s;
            }
          } else if (tiles[t].x == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + left!.s + lower!.s;
            } else {
              testScore = tiles[t].y + upper!.s + left!.s + lower!.s;
            }
          } else if (tiles[t].y == right?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + left!.s + lower!.s;
            } else {
              testScore = tiles[t].x + upper!.s + left!.s + lower!.s;
            }
          } else if (tiles[t].x == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + right!.s + left!.s;
            } else {
              testScore = tiles[t].y + upper!.s + right!.s + left!.s;
            }
          } else if (tiles[t].y == lower?.x) {
            matchList.add(tiles[t]);
            if (tiles[t].s > 0) {
              testScore = tiles[t].s + upper!.s + right!.s + left!.s;
            } else {
              testScore = tiles[t].x + upper!.s + right!.s + left!.s;
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domino Solver'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
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
            height: 20,
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
            children: List.generate(tiles.length, (inx) {
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
                      value: upper,
                      iconSize: 0,
                      isExpanded: true,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          upper = newValue!;
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
                      value: left,
                      iconSize: 0,
                      isExpanded: true,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          left = newValue!;
                        });
                      }),
                ),
              ),
              Container(
                width: 2 * boxWidth,
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
                      value: right,
                      iconSize: 0,
                      isExpanded: true,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          right = newValue!;
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
                      value: lower,
                      iconSize: 0,
                      isExpanded: true,
                      items: table.map((Tile val) {
                        return DropdownMenuItem<Tile>(
                          value: val,
                          child: Center(child: Text(val.name)),
                        );
                      }).toList(),
                      onChanged: (Tile? newValue) {
                        setState(() {
                          lower = newValue!;
                        });
                      }),
                ),
              )
            ],
          ),
          Text(
            style: const TextStyle(fontSize: 20, color: Colors.green),
            ' Matches $matchString ',
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
                    ' No Score ',
                  ),
          ),
          Text(
            style: const TextStyle(fontSize: 20, color: Colors.green),
            ' Score $maxScore ',
          ),
        ],
      ),
    );
  }
}
