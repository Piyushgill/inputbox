import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_html/flutter_html.dart';
import 'order_model.dart';
import 'second_screen.dart';
import 'thirdscreen.dart';
void main(){
  runApp(MaterialApp(home: FirstScreen(),
  debugShowCheckedModeBanner: false,));
}
class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<inputbox> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('research_items');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        items = jsonList.map((e) => inputbox.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString('research_items', json.encode(jsonList));
  }

  void _addOrUpdateItem(inputbox item, {int? index}) {
    setState(() {
      if (index != null && index >= 0) {
        items[index] = item;
      } else {
        items.add(item);
      }
      _saveItems();
    });
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      _saveItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('📚 Research Tracker'),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text('Image', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Short Desc.', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 4, child: Text('Long Desc.', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text("No items yet. Tap + to add.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdScreen(item: item, index: index),
                        ),
                      );
                      if (result != null && result is Map) {
                        if (result.containsKey('delete') && result['delete'] == true) {
                          _deleteItem(result['index']);
                        } else if (result.containsKey('inputbox')) {
                          _addOrUpdateItem(result['inputbox'], index: result['index']);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: item.imagePath != null && File(item.imagePath!).existsSync()
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(item.imagePath!),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon(Icons.image, size: 40, color: Colors.grey[500]),
                          ),
                          SizedBox(width: 6),
                          Expanded(flex: 2, child: Text(item.title, overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 3, child: Text(item.shortdescription, overflow: TextOverflow.ellipsis)),
                          Expanded(
                            flex: 4,
                            child: Html(
                              data: item.longdescription,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                  fontSize: FontSize(14),
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              },
                            ),
                          ),
                          Expanded(flex: 2, child: Text(item.Date)),
                          Expanded(
                            flex: 2,
                            child: Chip(
                              label: Text(item.status, style: TextStyle(color: Colors.white)),
                              backgroundColor: item.status.toLowerCase() == "completed"
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Research"),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondScreen()),
          );
          if (result != null && result is Map && result.containsKey('inputbox')) {
            _addOrUpdateItem(result['inputbox']);
          }
        },
      ),
    );
  }
}
