import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_modle/person.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Person> items = [
    Person(name: 'Ibad', address: 'Mardan'),
    Person( name: 'Ali', address: 'Peshawar'),
    Person( name: 'Uzair', address: 'Lahore'),
    Person( name: 'Maaz', address: 'Islamabad'),
  ];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList("items");

    if (savedList != null) {
      setState(() {
        items = savedList.map((item) {
          try {
            // Attempt to decode JSON
            final jsonData = json.decode(item);
            return Person.fromJson(jsonData);
          } catch (e) {
            // If JSON decoding fails, treat it as a plain string and convert to Person
            return Person(name: item, address: "Unknown Address");
          }
        }).toList();
      });
    }
  }

  Future<void> _saveItems() async {
    final stringList = items.map((person) => json.encode(person.toJson())).toList();
    await prefs.setStringList("items", stringList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drag items on list"),
      ),
      body: ReorderableListView.builder(
        itemCount: items.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
            _saveItems();
          });
        },
        itemBuilder: (context, index) {
          final person = items[index];
          return Container(
            key: ValueKey(person),
            color: Colors.grey[200],
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListTile(

              title: Text(person.name ?? ''),
              subtitle: Text(person.address ?? ''),
            ),
          );
        },
      ),
    );
  }
}
