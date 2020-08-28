import 'dart:convert';

import 'package:phonebook/models/Phone.dart';

class Phonebook {
  String listName;
  DateTime creationTime;
  List<Phone> phoneList;
  int status;
  String note;

  Phonebook({this.listName, this.creationTime, this.phoneList, this.status, this.note});

  Phonebook.fromJson(Map<String, dynamic> json) {
    listName = json['listName'];
    creationTime = DateTime.fromMillisecondsSinceEpoch(json['creationTime']);

    phoneList = (json['phoneList']).map((data) => Phone.fromJson(data)).cast<Phone>().toList();
    status = json['status'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    List<Map> phones =
    this.phoneList != null ? this.phoneList.map((i) => i.toJson()).toList() : null;

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listName'] = this.listName;
    data['creationTime'] = this.creationTime.millisecondsSinceEpoch;
    data['phoneList'] = phones;
    data['status'] = this.status;
    data['note'] = this.note;
    return data;
  }
}