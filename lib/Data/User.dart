import 'package:flutter/cupertino.dart';
import 'package:luxury_app_pre/Data/Order.dart';

class UserData {
  String id;
  String uid;
  String firstName;
  String lastName;
  String userName;
  int joinedDate;

  String address;
  String phoneNumber;
  String email;
  int size;

  int invitations;
  String notifications;

  String membership;



  ShoppingCart cart = new ShoppingCart();
  OrderList orders = new OrderList();
  ReturnsList returns = new ReturnsList();
  UserData(this.id, this.uid, this.firstName, this.lastName, this.userName, this.joinedDate, this.membership, {this.notifications="false", this.invitations=0, this.address="", this.phoneNumber="", this.email="", this.size=0});

  void toggleNotifications () {
    if (notifications == "true") {
      notifications = "false";
    }
    else {
      notifications = "true";
    }
  }
}

class ShoppingCart {
  List<OrderItem> listSelections = [];
  ValueNotifier<String> cartLength = ValueNotifier("");

  void getData (List<OrderItem> data) {
    listSelections = data;
  }

  void addSelection (OrderItem data) {
    listSelections.add(data);
    cartLength.value = listSelections.length.toString();
  }

  void removeSelection (OrderItem data) {
    listSelections.remove(data);
    cartLength.value = listSelections.length.toString();
  }
}

class OrderList {
  List<OrderData> listOrders = [];

  void getData (List<OrderData> data) {
    listOrders = data;
  }
}

class ReturnsList {
  List<ReturnData> listReturns = [];

  void getData (List<ReturnData> data) {
    listReturns = data;
  }
}