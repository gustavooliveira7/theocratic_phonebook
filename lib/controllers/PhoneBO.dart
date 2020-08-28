import 'package:phonebook/models/Phone.dart';
import 'package:flutter/material.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';


class PhoneBO {
  static const int NONE = 0;
  static const int UNAVAILABLE = 1;
  static const int NO_ANSWER = 2;
  static const int DO_NOT_CALL_AGAIN = 3;
  static const int RETURN_VISIT = 4;
  static const int STUDY = 5;

  static List<int> phoneStatus = [NONE, UNAVAILABLE, NO_ANSWER, DO_NOT_CALL_AGAIN, RETURN_VISIT, STUDY];


  static List<Phone> generateAutomaticList(String mainPhone, int qtd) {
    if (mainPhone != null && mainPhone.trim().isNotEmpty){
      List<Phone> phones = [];
      int initialNumber = int.parse(getUnformattedPhone(mainPhone));
      for (int i = 0; i < qtd; i++) {
        int number = initialNumber + i;
        phones.add(new Phone(number: number.toString(), obs: "", personName: "", status: PhoneBO.NONE));
      }

      return phones;
    }
    throw new Exception('Por favor, informe o primeiro número da lista!');
  }

  static String getUnformattedPhone(String phone) {
    return phone.trim().replaceAll(" ", "").replaceAll("-", "");
  }

  static Icon getIcon(int status){
    switch (status){
      case NONE: return Icon(Icons.star, color: UIFacade.textLightColor,);
      case UNAVAILABLE: return Icon(Icons.phonelink_erase, color: UIFacade.textLightColor,);
      case NO_ANSWER: return Icon(Icons.phone_missed, color: UIFacade.textLightColor,);
      case DO_NOT_CALL_AGAIN: return Icon(Icons.not_interested, color: UIFacade.textLightColor,);
      case RETURN_VISIT: return Icon(Icons.compare_arrows, color: UIFacade.textLightColor,);
      case STUDY: return Icon(Icons.book, color: UIFacade.textLightColor,);
      default: return Icon(Icons.bookmark);
    }
  }

  static String getStatusDescription(int status){
    switch (status){
      case NONE: return 'Ainda não liguei';
      case UNAVAILABLE: return 'Não existe';
      case NO_ANSWER: return 'Não atendeu';
      case DO_NOT_CALL_AGAIN: return 'Não ligar novamente';
      case RETURN_VISIT: return 'Revisita';
      case STUDY: return 'Estudo bíblico';
      default: return "Sem status";
    }
  }
}
