class Phone{


  String number;
  String personName;
  String obs;
  int status;

  Phone({this.number, this.personName, this.obs, this.status});

  Phone.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    personName = json['personName'];
    obs = json['obs'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['personName'] = this.personName;
    data['obs'] = this.obs;
    data['status'] = this.status;
    return data;
  }
}