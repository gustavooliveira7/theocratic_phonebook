import 'package:flutter/material.dart';
import 'package:phonebook/controllers/PhoneBO.dart';
import 'package:phonebook/controllers/PhonebookBO.dart';
import 'package:phonebook/controllers/RoutesBO.dart';
import 'package:phonebook/models/Phone.dart';
import 'package:phonebook/models/Phonebook.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';

class PhonebookDetailView extends StatefulWidget {
  Phonebook phonebook;
  int phone_quantity = 0;
  int phone_unavailables = 0;
  int phone_no_answer = 0;
  int phone_dont_call_again = 0;
  int phone_revisities = 0;
  int phone_studies = 0;

  PhonebookDetailView(Phonebook phonebook) {
    this.phonebook = phonebook;
  }

  @override
  _PhonebookStage createState() => _PhonebookStage();
}

class _PhonebookStage extends State<PhonebookDetailView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final obsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData(){
    setState(() {
      obsController.text = widget.phonebook.note;
    });
  }

  @override
  void dispose() {
    // LIMPA AS INSTANCIAS PARA LIBERAR MEMORIA
    nameController.dispose();
    obsController.dispose();

    super.dispose();
  }

  void edit(Phone phone) async {
    final result = await Navigator.pushNamed(context, RoutesBO.editPhone,
        arguments: phone);
    if (result != null) {
      int index = widget.phonebook.phoneList.indexOf(result);
      widget.phonebook.phoneList[index] = result;
      loadSummary();
    }
  }

  void save(BuildContext ctxt) {
    widget.phonebook.note = obsController.text;
    Navigator.pop(context, widget.phonebook);
  }

  void resetSummary() {
    widget.phone_quantity = 0;
    widget.phone_unavailables = 0;
    widget.phone_no_answer = 0;
    widget.phone_dont_call_again = 0;
    widget.phone_revisities = 0;
    widget.phone_studies = 0;
  }

  void loadSummary() {
    resetSummary();
    setState(() {
      widget.phone_quantity = widget.phonebook.phoneList.length;
      for (Phone phone in widget.phonebook.phoneList) {
        switch (phone.status) {
          case PhoneBO.UNAVAILABLE:
            widget.phone_unavailables += 1;
            break;
          case PhoneBO.NO_ANSWER:
            widget.phone_no_answer += 1;
            break;
          case PhoneBO.DO_NOT_CALL_AGAIN:
            widget.phone_dont_call_again += 1;
            break;
          case PhoneBO.RETURN_VISIT:
            widget.phone_revisities += 1;
            break;
          case PhoneBO.STUDY:
            widget.phone_studies += 1;
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadSummary();

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
          title: Text(widget.phonebook.listName),
          actions: <Widget>[
            IconButton(
              tooltip: 'Apagar Lista',
              icon: Icon(
                Icons.delete,
                color: UIFacade.textLightColor,
              ),
              /* onPressed: AQUI VAI DELETAR A LISTA, */
            ),
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        UIFacade.getSummaryCard('Telefones cadastrados',
                            widget.phone_quantity.toString()),
                        UIFacade.getSummaryCard(
                            'Estudos', widget.phone_studies.toString()),
                        UIFacade.getSummaryCard(
                            'Revisitas', widget.phone_revisities.toString()),
                        UIFacade.getSummaryCard(
                            'Não atenderam', widget.phone_no_answer.toString()),
                        UIFacade.getSummaryCard('Não ligar novamente',
                            widget.phone_dont_call_again.toString()),
                        UIFacade.getSummaryCard('Indisponíveis',
                            widget.phone_unavailables.toString()),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: UIFacade.getTextArea(
                              obsController, "Observações", false),
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
                                            color: (widget.phonebook.status ==
                                                    index)
                                                ? Colors.white
                                                : UIFacade.textDarkColor
                                                    .withOpacity(0.4),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      avatar: CircleAvatar(
                                        backgroundColor:
                                            (widget.phonebook.status == index)
                                                ? UIFacade.textDarkColor
                                                    .withOpacity(0)
                                                : UIFacade.appBackgroundColor
                                                    .withOpacity(0),
                                        child: PhonebookBO.getIcon(index),
                                      ),
                                      selected:
                                          widget.phonebook.status == index,
                                      selectedColor: UIFacade.textDarkColor
                                          .withOpacity(0.8),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          widget.phonebook.status = index;
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
                          visible: widget.phonebook.phoneList.length > 0,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: ExpansionTile(
                              title: UIFacade.getSubtitleText("Telefones"),
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  padding:
                                      new EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  itemCount: widget.phonebook.phoneList.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    final phone =
                                        widget.phonebook.phoneList[index];

                                    return Container(
                                      //padding: new EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child: Container(
                                          child: new GestureDetector(
                                        onTap: () {
                                          edit(phone);
                                          //selectedPhonebook = list;
                                          //edit();
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          color: UIFacade.cardColor,
                                          elevation: 10,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20, 0, 0, 0),
                                                trailing: MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .only(
                                                              topLeft: Radius
                                                                  .circular(0),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  elevation: 0,
                                                  minWidth: 60.0,
                                                  height: 60,
                                                  color: Color.fromRGBO(
                                                      211, 46, 47, 0.7),
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(Icons.cancel,
                                                      color: UIFacade
                                                          .textLightColor),
                                                  onPressed: () {
                                                    //removePhone(index);
                                                  },
                                                ),
                                                title: Text(
                                                    phone.number != null
                                                        ? UIFacade.applyMask(
                                                            UIFacade
                                                                .phoneController,
                                                            phone.number)
                                                        : ' - ',
                                                    style: TextStyle(
                                                        color: UIFacade
                                                            .textLightColor,
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Visibility(
          visible: widget.phonebook.phoneList.length > 0,
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
          ),
        ),
        backgroundColor: UIFacade.appBackgroundColor);
  }
}
