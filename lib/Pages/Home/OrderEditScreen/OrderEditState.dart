import 'package:flutter/cupertino.dart';
import 'package:luxury_app_pre/Data/Order.dart';

class OrderEditState {
  Function? changeState;
  Function? textOn;
  TextEditingController? textCont;

  int stage = 0;
  List<bool> itemSelect = [];
  List<bool> reasonSelect = [];
  List<bool> methodSelect = [];

  bool textActive = false;

  OrderItem? selection;
  String reason = "";
  String method = "";

  void changeStateFunction (Function f) {
    changeState = f;
  }

  void setTextFunction (Function f) {
    textOn = f;
  }

  void setTextActive () {
    textActive = true;
  }

  void setTextCont (TextEditingController controller) {
    textCont = controller;
  }

  void setTextInactive () {
    textActive = false;
  }

  void setReason (String data) {
    reason = data;
  }

  void setMethod (String data) {
    method = data;
  }

  void nextStage ({OrderItem? data, String? data2}) {
    if (data != null) {
      selection = data;
    }
    if (data2 != null) {
      reason = data2;
    }
    stage++;
  }

  void previousStage () {
    stage--;
  }
}