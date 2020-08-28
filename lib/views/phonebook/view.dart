import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonebook/controllers/PhonebookBO.dart';
import 'package:phonebook/controllers/RoutesBO.dart';
import 'package:phonebook/models/Phonebook.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  var lists = new List<Phonebook>();

  HomePage() {
    lists = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('phonebooks');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Phonebook> result =
          decoded.map((e) => Phonebook.fromJson(e)).toList();
      setState(() {
        widget.lists = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('phonebooks', jsonEncode(widget.lists));
  }

  void remove(int index) {
    setState(() {
      widget.lists.removeAt(index);
      save();
    });
  }

  void add(Phonebook p) {
    setState(() {
      widget.lists.add(p);
      save();
    });
  }

  void newBook() async {
    final result = await Navigator.pushNamed(context, RoutesBO.addNewPhonebook);
    if (result != null) {
      add(result);
    }
  }

  void edit(Phonebook list) async {
    final result = await Navigator.pushNamed(context, RoutesBO.editList, arguments: list);
    if (result != null) {
      setState(() {
        int index = widget.lists.indexOf(result);
        widget.lists[index] = result;
      });
    }
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.contacts),
        title: Text("Listas telefônicas"),
      ),
      body: ListView.builder(
        itemCount: widget.lists.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final list = widget.lists[index];

          return Dismissible(
              child: Container(
                padding: new EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Container(
                    child: new GestureDetector(
                  onTap: () {
                    //selectedPhonebook = list;
                    edit(list);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: UIFacade.cardColor,
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Padding(
                            padding: new EdgeInsets.only(top: 7.5),
                            child: PhonebookBO.getIcon(list.status),
                          ),
                          title: Text(
                              list.listName != null
                                  ? list.listName
                                  : 'Lista sem nome',
                              style: TextStyle(
                                  color: UIFacade.textLightColor,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              PhonebookBO.getStatusDescription(list.status) +
                                  (list.note != null && list.note.isNotEmpty
                                      ? ' | ' + list.note
                                      : ''),
                              style: TextStyle(
                                  color: UIFacade.textLightColor,
                                  fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
              key: Key(list.creationTime.toString()),
              onDismissed: (direction) {
                remove(index);
              },
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.black.withOpacity(0.7),
                child: Icon(
                  Icons.delete,
                  size: 70,
                  color: Colors.white.withOpacity(0.5),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20.0),
              ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: UIFacade.primaryColor,
        child: const Icon(
          Icons.add,
          color: Color.fromRGBO(237, 231, 246, 1),
        ),
        tooltip: "Adicionar nova lista",
        onPressed: () {
          newBook();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        color: UIFacade.bottomBarColor,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
      backgroundColor: UIFacade.appBackgroundColor,
    );
  }
}
