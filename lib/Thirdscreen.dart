import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'order_model.dart';
import 'second_screen.dart';

class ThirdScreen extends StatelessWidget {
  final inputbox item;
  final int index;

  ThirdScreen({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Navigator.pop(context, {'delete': true, 'index': index});
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imagePath != null && File(item.imagePath!).existsSync()
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(item.imagePath!),
                height: 200,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 100),
            ),

            SizedBox(height: 16),
            Text("Title :-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(item.title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text("Short Description :-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(item.shortdescription, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text("Long Description :-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Html(
              data: item.longdescription,
              style: {
                "body": Style(fontSize: FontSize(16)),
              },
            ),
            SizedBox(height: 12),
            Text("Date :-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(item.Date, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text("Status :-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Chip(
              label: Text(item.status, style: TextStyle(color: Colors.white)),
              backgroundColor: item.status.toLowerCase() == "completed"
                  ? Colors.green
                  : Colors.orange,
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(
                        existingInput: item,
                        index: index,
                      ),
                    ),
                  );
                  Navigator.pop(context, result);
                },
                icon: Icon(Icons.edit),
                label: Text("Update"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
