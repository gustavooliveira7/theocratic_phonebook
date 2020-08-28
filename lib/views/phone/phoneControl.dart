import 'package:flutter/material.dart';
import 'package:phonebook/controllers/PhoneBO.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';
import 'package:phonebook/models/Phone.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class PhoneControl extends StatefulWidget {
  var phones = new List<Phone>();

  PhoneControl() {
    phones = [];
  }

  @override
  _PhoneStage createState() => _PhoneStage();
}

class _PhoneStage extends State<PhoneControl> {
  final List<String> options = ['Lista automática', 'Lista Manual'];

  final phoneController =
      new MaskedTextController(mask: UIFacade.phoneController);
  final _formPhonesKey = GlobalKey<FormState>();
  int qtdTelefones = 50;

  @override
  void dispose() {
    widget.phones = [];
    qtdTelefones = 50;
    phoneController.dispose();

    super.dispose();
  }

  void confirm() {
    Navigator.pop(context, widget.phones);
  }

  void removePhone(int index) {
    setState(() {
      widget.phones.removeAt(index);
    });
  }

  void generateAutoList() {
    setState(() {
      widget.phones =
          PhoneBO.generateAutomaticList(phoneController.text, qtdTelefones);
      //Navigator.pop(context, widget.phones);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String listName = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: options.length,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Adicionando telefones ' +
                (listName != null ? '(' + listName + ')' : '')),
            bottom: TabBar(
              indicatorColor: UIFacade.textLightColor,
              labelColor: UIFacade.textLightColor,
              unselectedLabelColor: UIFacade.decorationColor,
              tabs: List<Widget>.generate(options.length, (int index) {
                return new Tab(text: options[index]);
              }),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            child: TabBarView(
              children: [
                Container(
                  child: Column(children: <Widget>[
                    Visibility(
                      visible: widget.phones.length == 0,
                      child: Column(children: <Widget>[
                        SingleChildScrollView(
                          padding: EdgeInsets.only(top: 20),
                          child: Form(
                            key: _formPhonesKey,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: UIFacade.getPhoneTextField(
                                            phoneController,
                                            "Primeiro número da lista",
                                            true),
                                      ),
                                    ])),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  UIFacade.getDescriptionText(
                                      'Quantidade de telefones da lista: '),
                                  Flexible(
                                      child: Container(
                                    width: 105,
                                    child: DropdownButtonFormField<int>(
                                      value: qtdTelefones,
                                      items: [
                                        10,
                                        20,
                                        30,
                                        40,
                                        50,
                                        60,
                                        70,
                                        80,
                                        90,
                                        100
                                      ]
                                          .map((label) => DropdownMenuItem(
                                                child: Text(
                                                  label.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24,
                                                      color: UIFacade
                                                          .decorationColor),
                                                ),
                                                value: label,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() => qtdTelefones = value);
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          ),
                                    ),
                                  )),
                                ])),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            elevation: 5.0,
                            minWidth: 350.0,
                            height: 50,
                            color: UIFacade.primaryColor,
                            child: new Text('Gerar lista',
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: UIFacade.textLightColor)),
                            onPressed: () {
                              if (_formPhonesKey.currentState.validate()) {
                                generateAutoList();
                              }
                            },
                          ),
                        ),
                      ]),
                    ),
                    Visibility(
                        visible: widget.phones.length > 0,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: Column(
                              children: <Widget>[
                                UIFacade.getDescriptionText(
                                    'Confirme os números abaixo e clique no botão confirmar'),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          elevation: 5.0,
                                          minWidth: 50.0,
                                          height: 35,
                                          color: UIFacade.primaryColor,
                                          child: new Text('Limpar lista',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color:
                                                      UIFacade.textLightColor)),
                                          onPressed: () {
                                            setState(() {
                                              widget.phones.clear();
                                            });
                                          },
                                        ),
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          elevation: 5.0,
                                          minWidth: 50.0,
                                          height: 35,
                                          color: UIFacade.primaryColor,
                                          child: new Text('Confirmar',
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color:
                                                      UIFacade.textLightColor)),
                                          onPressed: () {
                                            confirm();
                                          },
                                        ),
                                      ]),
                                ),
                              ],
                            ))),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.phones.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          final phone = widget.phones[index];

                          return Container(
                                padding: new EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Container(
                                    child: new GestureDetector(
                                  onTap: () {
                                    //selectedPhonebook = list;
                                    //edit();
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
                                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0) ,
                                          trailing: MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight:  Radius.circular(10), bottomLeft:  Radius.circular(0), bottomRight:  Radius.circular(10))),
                                            elevation: 0,
                                            minWidth: 60.0,
                                            height: 60,
                                            color: Color.fromRGBO(211, 46, 47, 0.7),
                                            padding: EdgeInsets.all(10),
                                            child: Icon(Icons.cancel,
                                                color: UIFacade.textLightColor),
                                            onPressed: () {
                                              removePhone(index);
                                            },
                                          ),
                                          title: Text(
                                              phone.number != null
                                                  ? UIFacade.applyMask(
                                                      UIFacade.phoneController,
                                                      phone.number)
                                                  : ' - ',
                                              style: TextStyle(
                                                  color:
                                                      UIFacade.textLightColor,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              );
                        },
                      ),
                    ),
                  ]),
                ),
                Center(
                  child: UIFacade.getSubtitleText('Em desenvolvimento'),
                ),
              ],
            ),
          ),
          backgroundColor: UIFacade.appBackgroundColor),
    );
  }
/**/
}
