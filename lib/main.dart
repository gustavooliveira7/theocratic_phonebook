import 'package:flutter/material.dart';
import 'package:phonebook/controllers/RoutesBO.dart';
import 'package:phonebook/models/Phonebook.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';
import 'package:phonebook/views/phone/PhoneView.dart';
import 'package:phonebook/views/phone/phoneControl.dart';
import 'package:phonebook/views/phonebook/DetailView.dart';
import 'package:phonebook/views/phonebook/insert.dart';
import 'package:phonebook/views/phonebook/view.dart';


Phonebook selectedPhonebook;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Telefônica Teocrática',
      theme: ThemeData(
        primaryColor: UIFacade.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        RoutesBO.home: (context) => HomePage(),
        RoutesBO.addNewPhonebook: (context) => NewPhonebook(),
        RoutesBO.insertPhones: (context) => PhoneControl(),
        RoutesBO.editList: (context) => PhonebookDetailView(ModalRoute.of(context).settings.arguments),
        RoutesBO.editPhone: (context) => PhoneView(ModalRoute.of(context).settings.arguments),
      },
    );
  }
}




