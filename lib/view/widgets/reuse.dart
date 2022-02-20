import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  String noteText;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(UniqueKey().toString()),
      background: Container(
        child: Icon(
          Icons.delete,
          size: 40,
        ),
        color: Colors.red,
      ),
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,

          leading: Icon(Icons.date_range),
          title: Text("1/11/2022"),
          children: [
            Text(
              noteText,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
