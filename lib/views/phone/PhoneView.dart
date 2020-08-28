import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonebook/controllers/PhoneBO.dart';
import 'package:phonebook/models/Phone.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneView extends StatefulWidget {
  Phone phone;
  int status = 0;

  PhoneView(Phone phone) {
    this.phone = phone;
  }

  @override
  _PhoneStage createState() => _PhoneStage();
}

class _PhoneStage extends State<PhoneView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final obsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void call(String number){
    launch("tel:$number");
  }

  void sms(String number){
    launch("sms:$number");
  }

  void whatsApp(BuildContext ctxt, String number) async {
    var whatsAppUrl ="whatsapp://send?phone=+55034$number";
    await canLaunch(whatsAppUrl)? launch(whatsAppUrl) : UIFacade.showAlertDialog(context, "Não foi possível acionar o WhatsApp");
  }

  void save(BuildContext ctxt) {
    setState(() {
      widget.phone.personName = nameController.text;
      widget.phone.obs = obsController.text;
      Navigator.pop(context, widget.phone);
    });
  }

  void loadData(){
    setState(() {
      nameController.text = widget.phone.personName;
      obsController.text = widget.phone.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              save(context);
            },
          ),
          title: Text(UIFacade.applyMask(
              UIFacade.phoneController, widget.phone.number)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                UIFacade.getTextField(nameController, "Nome do contato", true),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child:
                  UIFacade.getTextArea(obsController, "Observações", false),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: UIFacade.getSubtitleText("Status"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                  child: Column(children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List<Widget>.generate(
                        PhoneBO.phoneStatus.length,
                            (int index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: ChoiceChip(
                              label: Text(
                                PhoneBO.getStatusDescription(index),
                                style: TextStyle(
                                    color: (widget.phone.status == index)
                                        ? Colors.white
                                        : UIFacade.textDarkColor
                                        .withOpacity(0.4),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              avatar: CircleAvatar(
                                backgroundColor: (widget.status == index)
                                    ? UIFacade.textDarkColor.withOpacity(0)
                                    : UIFacade.appBackgroundColor
                                    .withOpacity(0),
                                child: PhoneBO.getIcon(index),
                              ),
                              selected: widget.phone.status == index,
                              selectedColor:
                              UIFacade.textDarkColor.withOpacity(0.8),
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.phone.status = index;
                                });
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[

                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          elevation: 5.0,
                          minWidth: 100.0,
                          height: 50,
                          color: UIFacade.primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.call, color: UIFacade.textLightColor,),
//                              Text('Ligar',
//                                  style: new TextStyle(
//                                      fontSize: 18, color: UIFacade.textLightColor))
                            ],
                          ),
                          onPressed: () {
                            call(widget.phone.number);
                          },
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          elevation: 5.0,
                          minWidth: 100.0,
                          height: 50,
                          color: UIFacade.primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FaIcon(FontAwesomeIcons.whatsapp, color: UIFacade.textLightColor,),
//                              Text('Ligar',
//                                  style: new TextStyle(
//                                      fontSize: 18, color: UIFacade.textLightColor))
                            ],
                          ),
                          onPressed: () {
                            whatsApp(context, widget.phone.number);
                          },
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          elevation: 5.0,
                          minWidth: 100.0,
                          height: 50,
                          color: UIFacade.primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              FaIcon(FontAwesomeIcons.solidCommentAlt, color: UIFacade.textLightColor,),
//                              Text('Ligar',
//                                  style: new TextStyle(
//                                      fontSize: 18, color: UIFacade.textLightColor))
                            ],
                          ),
                          onPressed: () {
                            sms(widget.phone.number);
                          },
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: UIFacade.primaryColor,
          child: const Icon(
            Icons.done,
            color: Color.fromRGBO(237, 231, 246, 1),
          ),
          tooltip: "Salvar",
          onPressed: () {
            save(context);
          },
        ),
        backgroundColor: UIFacade.appBackgroundColor);
  }
}
