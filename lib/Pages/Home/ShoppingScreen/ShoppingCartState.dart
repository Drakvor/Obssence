import 'package:flutter/animation.dart';
import 'package:luxury_app_pre/Data/Order.dart';

class ShoppingCartState {
  int state = 0; // 0 = normal, 1 = change quantity, 2 = change size
  OrderItem? selection;
  int quantity = -1;
  int size = -1;


  void setState (int data) {
    state = data;
  }

  void setSelection (OrderItem data) {
    selection = data;
    size = selection!.item!.availableSizes!.indexOf(selection!.size);
    quantity = selection!.quantity;
  }

  void setSize (int data) {
    size = data;
  }

  void setQuantity (int data) {
    quantity = data;
  }
}