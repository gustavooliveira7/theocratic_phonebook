import 'package:flutter/material.dart';
import 'package:phonebook/controllers/PhonebookBO.dart';
import 'package:phonebook/controllers/RoutesBO.dart';
import 'package:phonebook/models/Phone.dart';
import 'package:phonebook/models/Phonebook.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';

class NewPhonebook extends StatefulWidget {
  var phones = new List<Phone>();
  int status = 0;

  NewPhonebook() {
    phones = [];
    status = 0;
  }

  @override
  _PhonebookStage createState() => _PhonebookStage();
}

class _PhonebookStage extends State<NewPhonebook> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final obsController = TextEditingController();

  @override
  void dispose() {

    // LIMPA AS INSTANCIAS PARA LIBERAR MEMORIA
    nameController.dispose();
    obsController.dispose();

    super.dispose();
  }

  bool validate(BuildContext ctxt) {
    if (_formKey.currentState.validate()){
      if (widget.phones.length <= 0){
        UIFacade.showAlertDialog(ctxt, 'Adicione os números de telefone!');
        return false;
      }
      return true;
    }
    return false;
  }

  void save(BuildContext ctxt) {
    if (validate(ctxt)){
      Phonebook phonebook = Phonebook(
          creationTime: DateTime.now(),
          listName: nameController.text,
          phoneList: widget.phones,
          status: widget.status,
          note: obsController.text);
      Navigator.pop(context, phonebook);
    }
  }

  void generateList() async {
    if (_formKey.currentState.validate()) {
      widget.phones = [];
      final result = await Navigator.pushNamed(context, RoutesBO.insertPhones,
          arguments: nameController.text);
      if (result != null) {
        setState(() {
          widget.phones = result;
        });
      }
    }
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
              Navigator.pop(context);
            },
          ),
          title: Text("Nova Lista"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                UIFacade.getTextField(nameController, "Nome da lista", true),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child:
                      UIFacade.getTextArea(obsController, "Observações", false),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: UIFacade.getSubtitleText("Status da lista"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                  child: Column(children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List<Widget>.generate(
                        PhonebookBO.listStatus.length,
                        (int index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: ChoiceChip(
                              label: Text(
                                PhonebookBO.getStatusDescription(index),
                                style: TextStyle(
                                    color: (widget.status == index)
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
                                child: PhonebookBO.getIcon(index),
                              ),
                              selected: widget.status == index,
                              selectedColor:
                                  UIFacade.textDarkColor.withOpacity(0.8),
                              onSelected: (bool selected) {
                                setState(() {
                                  widget.status = index;
                                });
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ]),
                ),
                Visibility(
                  visible: widget.phones.length <= 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      elevation: 5.0,
                      minWidth: 350.0,
                      height: 50,
                      color: UIFacade.primaryColor,
                      child: new Text('Adicionar números de telefone',
                          style: new TextStyle(
                              fontSize: 18, color: UIFacade.textLightColor)),
                      onPressed: () {
                        generateList();
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.phones.length > 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          UIFacade.getDescriptionText(
                              'Telefones adicionados com sucesso!'),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Visibility(
    visible: widget.phones.length > 0,
    child: FloatingActionButton(
          backgroundColor: UIFacade.primaryColor,
          child: const Icon(
            Icons.done,
            color: Color.fromRGBO(237, 231, 246, 1),
          ),
          tooltip: "Salvar",
          onPressed: () {

            save(context);
          },
        ),),
        backgroundColor: UIFacade.appBackgroundColor);
  }
}
