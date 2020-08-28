import 'package:flutter/material.dart';
import 'package:phonebook/views/Utils/UIFacade.dart';

class PhonebookBO{
  static const int NONE = 0;
  static const int IN_PROGRESS = 1;
  static const int FINISHED = 2;
  static const int CANCELLED = 3;

  static List<int> listStatus = [NONE, IN_PROGRESS, FINISHED, CANCELLED];

  static Icon getIcon(int status){
    switch (status){
      case NONE: return Icon(Icons.star, color: UIFacade.textLightColor,);
      case IN_PROGRESS: return Icon(Icons.label_important, color: UIFacade.textLightColor,);
      case FINISHED: return Icon(Icons.check_circle, color: UIFacade.textLightColor,);
      case CANCELLED: return Icon(Icons.block, color: UIFacade.textLightColor,);
      default: return Icon(Icons.bookmark);
    }
  }

  static String getStatusDescription(int status){
    switch (status){
      case NONE: return 'Não iniciada';
      case IN_PROGRESS: return 'Em andamento';
      case FINISHED: return 'Finalizada';
      case CANCELLED: return 'Cancelada';
      default: return "Sem status";
    }
  }
}