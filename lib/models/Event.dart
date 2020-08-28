import 'package:phonebook/models/Phone.dart';
import 'package:phonebook/models/PhoneStatus.dart';

class Event {
  Phone phoneNumber;
  PhoneStatus status;
  DateTime eventDate;
  String obs;

  Event({this.phoneNumber, this.status, this.eventDate, this.obs});

  Event.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    eventDate = json['eventDate'];
    obs = json['obs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['status'] = this.status;
    data['eventDate'] = this.eventDate;
    data['obs'] = this.obs;
    return data;
  }

}