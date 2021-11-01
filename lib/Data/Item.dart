import 'package:luxury_app_pre/Data/Sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemData {
  String name;
  String subtitle;
  String id;
  String description;
  String descriptionLong;
  Map<dynamic, dynamic>? materials = {};
  String madeIn;
  String sku;
  int price;
  List<String>? availableSizes = [];
  int availableNumber;

  //how to do sales?
  Sale? sale;
  String saleID;

  String brand;
  String category1; //type of clothing
  String category2; //release year
  ItemData({this.name = "", this.subtitle = "", this.id = "", this.brand = "", this.description = "", this.descriptionLong = "", this.price = 0, this.saleID="", this.sale, this.sku = "", this.availableSizes, this.availableNumber=1, this.materials, this.madeIn="", this.category1="", this.category2=""});

  void setSale (Sale data) {
    sale = data;
  }

  Future<void> getSale () async {
    CollectionReference sales = FirebaseFirestore.instance.collection('sales');
    DocumentSnapshot snapshot = await sales.doc(saleID).get();
    sale = Sale(snapshot.id, snapshot["name"], snapshot["value"]);
  }
}