import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:luxury_app_pre/Data/Brand.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Tags.dart';
import 'package:luxury_app_pre/Data/User.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class DataManager {
  String textInput = "";
  List<String> textList = [];

  UserData? user;
  SearchTags? tags;
  List<ItemData>? items;
  List<OrderData>? orders;
  List<Brand>? brands;

  String apiKey = "4248e76ac1684446091c214ccde68c2037";
  String sessionId = "";
  DataManager({this.user, this.tags, this.items, this.orders});

  void setTextInput (String data) {
    textInput = data;
    textList = data.split(" ");
  }

  Future<void> getSearchData () async {
    CollectionReference productsRef = FirebaseFirestore.instance.collection('items');

    QuerySnapshot snapshot = await productsRef.orderBy("date").where("name", whereIn: textList).get();
    List<ItemData> itemList1 = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      ItemData newItem = ItemData(
        name: snapshot.docs[i]["name"],
        id: snapshot.docs[i].id,
        brand: snapshot.docs[i]["brand"],
        description: snapshot.docs[i]["description"],
        descriptionLong: "",
        price: snapshot.docs[i]["price"],
        sku: snapshot.docs[i]["sku"],
        madeIn: snapshot.docs[i]["madeIn"],
        saleID: snapshot.docs[i]["sale"],
        availableSizes: snapshot.docs[i]["sizes"].cast<String>(),
        availableNumber: snapshot.docs[i]["availableNumber"],
      );
      await newItem.getSale();
      itemList1.add(newItem);
    }

    snapshot = await productsRef.orderBy("date").where("brand", whereIn: textList).get();
    List<ItemData> itemList2 = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      ItemData newItem = ItemData(
        name: snapshot.docs[i]["name"],
        id: snapshot.docs[i].id,
        brand: snapshot.docs[i]["brand"],
        description: snapshot.docs[i]["description"],
        descriptionLong: "",
        price: snapshot.docs[i]["price"],
        sku: snapshot.docs[i]["sku"],
        madeIn: snapshot.docs[i]["madeIn"],
        saleID: snapshot.docs[i]["sale"],
        availableSizes: snapshot.docs[i]["sizes"].cast<String>(),
        availableNumber: snapshot.docs[i]["availableNumber"],
      );
      await newItem.getSale();
      itemList2.add(newItem);
    }

    snapshot = await productsRef.orderBy("date").where("tags", arrayContainsAny: textList).get();
    List<ItemData> itemList3 = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      ItemData newItem = ItemData(
        name: snapshot.docs[i]["name"],
        id: snapshot.docs[i].id,
        brand: snapshot.docs[i]["brand"],
        description: snapshot.docs[i]["description"],
        descriptionLong: "",
        price: snapshot.docs[i]["price"],
        sku: snapshot.docs[i]["sku"],
        madeIn: snapshot.docs[i]["madeIn"],
        saleID: snapshot.docs[i]["sale"],
        availableSizes: snapshot.docs[i]["sizes"].cast<String>(),
        availableNumber: snapshot.docs[i]["availableNumber"],
      );
      await newItem.getSale();
      itemList3.add(newItem);
    }

    for (int i = 0; i < itemList1.length; i++) {
      if (itemList2.contains(itemList1[i])) {
        itemList2.remove(itemList1[i]);
      }
      if (itemList3.contains(itemList1[i])) {
        itemList3.remove(itemList1[i]);
      }
    }

    for (int i = 0; i < itemList2.length; i++) {
      if (itemList3.contains(itemList2[i])) {
        itemList3.remove(itemList2[i]);
      }
    }

    itemList2.addAll(itemList3);
    itemList1.addAll(itemList2);
    items = itemList1;
  }

  Future<bool> getUserData () async {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    utils.appManager.setLoggedOut();
    if (FirebaseAuth.instance.currentUser != null) {
      utils.appManager.setLoggedIn();
      QuerySnapshot snapshot = await usersRef.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      user = UserData(snapshot.docs[0].id, snapshot.docs[0]["uid"], "Amos", "Kwon", "Drakvor", 20210910, "Admin", size: 44, invitations: snapshot.docs[0]["invitations"], notifications: snapshot.docs[0]["notifications"], address: "경기도 성남시 분당구 서현동 91 시번한양아파트 327동 1309호", email: "hello@obssence.com", phoneNumber: "010-6580-9860");
      await getCartData();
    }
    await getBrandData();

    return true;
  }

  Future<void> getBrandData () async {
    CollectionReference brandsRef = FirebaseFirestore.instance.collection('brands');

    QuerySnapshot snapshot = await brandsRef.get();

    List<Brand> listBrands = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      Brand newBrand = Brand(
        name: snapshot.docs[i]["name"],
      );
      listBrands.add(newBrand);
    }
    listBrands.add(Brand(
      name: "Upcoming",
    ));
    brands = listBrands;
  }

  Future<void> getItemData () async {
    CollectionReference productsRef = FirebaseFirestore.instance.collection('items');

    QuerySnapshot snapshot = await productsRef.orderBy("date").get();
    List<ItemData> itemList = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      ItemData newItem = ItemData(
        name: snapshot.docs[i]["name"],
        id: snapshot.docs[i].id,
        brand: snapshot.docs[i]["brand"],
        description: snapshot.docs[i]["description"],
        descriptionLong: "",
        price: snapshot.docs[i]["price"],
        sku: snapshot.docs[i]["sku"],
        madeIn: snapshot.docs[i]["madeIn"],
        saleID: snapshot.docs[i]["sale"],
        availableSizes: snapshot.docs[i]["sizes"].cast<String>(),
        availableNumber: snapshot.docs[i]["availableNumber"],
      );
      await newItem.getSale();
      itemList.add(newItem);
    }
    items = itemList;
  }

  Future<void> getCartData () async {
    CollectionReference selectionsRef = FirebaseFirestore.instance.collection('selections');

    QuerySnapshot snapshot = await selectionsRef.where('parent', isEqualTo: user!.id).get();

    List<OrderItem> selectionList = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      OrderItem newSelection = OrderItem(
        id: snapshot.docs[i].id,
        itemId: snapshot.docs[i]["item"],
        size: snapshot.docs[i]["size"],
        quantity: snapshot.docs[i]["quantity"],
      );
      selectionList.add(newSelection);
    }
    user!.cart.getData(selectionList);

    for (int i = 0; i < user!.cart.listSelections.length; i++) {
      await user!.cart.listSelections[i].getItemData();
      await user!.cart.listSelections[i].item!.getSale();
    }
    user!.cart.cartLength.value = user!.cart.listSelections.length.toString();
  }

  Future<void> getReturnData () async {
    CollectionReference returnsRef = FirebaseFirestore.instance.collection('returns');

    QuerySnapshot snapshot = await returnsRef.where('user', isEqualTo: user!.id).get();

    List<ReturnData> returnList = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      ReturnData newReturns = ReturnData(
        id: snapshot.docs[i]["id"],
        oid: snapshot.docs[i]["oid"],
        returnDate: snapshot.docs[i]["returnDate"],
        status: snapshot.docs[i]["status"],
        reason: snapshot.docs[i]["reason"],
      );
      returnList.add(newReturns);
    }
    user!.returns.getData(returnList);

    for (int i = 0; i < user!.returns.listReturns.length; i++) {
      await user!.returns.listReturns[i].getSelection();
    }
  }

  Future<void> getOrderData () async {
    CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');

    QuerySnapshot snapshot = await ordersRef.where('user', isEqualTo: user!.id).get();

    List<OrderData> orderList = [];
    for (int i = 0; i < snapshot.docs.length; i++) {
      OrderData newOrder = OrderData(
        id: snapshot.docs[i]["id"],
        selectionIds: snapshot.docs[i]["items"].cast<String>(),
        returnIds: snapshot.docs[i]["returns"].cast<String>(),
        orderDate: snapshot.docs[i]["orderDate"],
        trackingId: snapshot.docs[i]["trackingId"],
        oid: snapshot.docs[i]["oid"],
      );
      orderList.add(newOrder);
    }
    user!.orders.getData(orderList);

    for (int i = 0; i < user!.orders.listOrders.length; i++) {
      await user!.orders.listOrders[i].getSelections();
    }
  }

  Future<void> accessApi () async {
    var res = await Dio().post("https://sboapicc.ecount.com/OAPI/V2/OAPILogin", data: {
      "COM_CODE": 620471,
      "USER_ID": "Admin",
      "API_CERT_KEY": apiKey,
      "LAN_TYPE": "ko_KR",
      "ZONE": "cc",
    });
    sessionId = res.data["Data"]["Datas"]["SESSION_ID"];
  }

  Future<void> postOrder (List<OrderItem> data) async {
    List params = [];
    for (int i = 0; i < data.length; i++) {
      params.add(
        {
          "Line": "0",
          "BulkDatas": {
            "IO_DATE": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
            "UPLOAD_SER_NO": "",
            "WH_CD": "100",
            "U_MEMO1": "sdfh2h3h",
            "PROD_CD": data[i].item!.id,
            "QTY": data[i].quantity.toString(),
            "PRICE": data[i].item!.price.toString(),
          }
        },
      );
    }
    var res = await Dio().post("https://sboapicc.ecount.com/OAPI/V2/Sale/SaveSale?SESSION_ID=" + sessionId, data: {
      "SaleList": params,
    });
    print(res);
  }

  Future<void> getStock (String product) async {
    var res = await Dio().post("https://sboapicc.ecount.com/OAPI/V2/InventoryBalance/ViewInventoryBalanceStatus?SESSION_ID=" + sessionId, data: {
      "SaleList": [
        {
          "Line": "0",
          "BulkDatas": {
            "BASE_DATE": (DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day).toString(),
            "WH_CD": "100",
            "PROD_CD": product,
          }
        },
      ],
    });
    print(res);
  }
}