import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/model/notes.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
  Colors.deepOrange,
  Colors.redAccent,
  Colors.brown
];

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key key,
    this.note,
    this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    // final hour = note.createdTime.hour;
    final minute = note.createdTime.minute;
    final charCount = note.description.length + note.title.length;

    var m;
    if (minute < 10) {
      m = '0' + minute.toString();
    } else {
      m = minute.toString();
    }

    /// To return different height for different widgets
    double getMinHeight(int noChar) {
      if (noChar < 16) {
        return 50;
      } else if (noChar < 32) {
        return 100;
      } else {
        return 120;
      }
      // switch (index % 4) {
      //   case 0:
      //     return 100;
      //   case 1:
      //     return 150;
      //   case 2:
      //     return 150;
      //   case 3:
      //     return 100;
      //   default:
      //     return 100;
      // }
    }

    final minHeight = getMinHeight(charCount);

    return Card(
      elevation: 5,
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                SizedBox(height: 4),
                Text(
                  note.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  note.description,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            // SizedBox(height:10),
            Positioned(
              child: Row(children: [
                Icon(
                  Icons.timer,
                  size: 16,
                ),
                Text('${note.createdTime.hour}:$m')
              ]),
              bottom: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
