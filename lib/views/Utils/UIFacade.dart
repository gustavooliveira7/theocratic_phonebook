import 'package:flutter/material.dart';

class UIFacade {
  static String phoneController = '0 0000 0000';
  /* CORES PADROES DA APLICACAO */
  static final appBackgroundColor = Color.fromRGBO(219, 214, 211, 1);
  static final bottomBarColor = Color.fromRGBO(245, 240, 237, 1);
  static final primaryColor = Color.fromRGBO(60, 56, 54, 1);
  static final textLightColor = Color.fromRGBO(253, 247, 245, 1);
  static final textDarkColor = primaryColor;
  static final decorationColor = Color.fromRGBO(150, 146, 143, 1);
  static final cardColor = Color.fromRGBO(91, 86, 84, 1);
  static final editColor = Color.fromRGBO(235, 230, 227, 1);

  static Text getSubtitleText(String label) {
    return Text(
      label,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
      textAlign: TextAlign.left,
    );
  }

  static TextFormField getTextField(
      TextEditingController controller, String label, bool required) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 1,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      validator: (value) {
        if (required && value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: decorationColor),
          fillColor: editColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
    );
  }

  static TextFormField getTextArea(
      TextEditingController controller, String label, bool required) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 3,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      validator: (value) {
        if (required && value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          fillColor: editColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
    );
  }

  static TextFormField getPhoneTextField(
      TextEditingController controller, String label, bool required) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      maxLines: 1,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      validator: (value) {
        if (required && value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          fillColor: editColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
    );
  }

  static Text getDescriptionText(String label) {
    return Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey));
  }

  static Text getSummaryTitle(String label) {
    return Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: textLightColor));
  }

  static Text getSummarySubtitle(String label) {
    return Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 18, color: textLightColor));
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': new RegExp(r'[A-Za-z]'),
      '0': new RegExp(r'[0-9]'),
      '@': new RegExp(r'[A-Za-z0-9]'),
      '*': new RegExp(r'.*')
    };
  }

  static String applyMask(String mask, String value) {
    Map<String, RegExp> translator = getDefaultTranslator();
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }

  static void showAlertDialog(BuildContext context, String text) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oops!"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Card getSummaryCard(String title, String text){
    return new  Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: UIFacade.cardColor,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: new BoxConstraints(
              minWidth: 120.0,
            ),
            child: Column(
              children: <Widget>[
                getSummaryTitle(title),
                getSummarySubtitle(text),
              ],
            ),
          ) ,
        ));
  }

  static void showNotification(BuildContext ctx, String text) {
    final snackBar = SnackBar(content: Text(text));

    Scaffold.of(ctx).showSnackBar(snackBar);
  }
}
