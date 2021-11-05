import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  String id;
  String oid;
  List<OrderItem>? selections = [];
  List<String>? selectionIds = [];
  List<String>? returnIds = [];
  List<ReturnData>? returns = [];
  String trackingId;
  String orderStatus;
  String deliveryStatus;
  int orderDate;
  int expectedDate;
  OrderData({this.id="", this.oid="", this.selections, this.selectionIds, this.returns, this.returnIds, this.trackingId="", this.orderDate=0, this.expectedDate=0, this.orderStatus="", this.deliveryStatus=""});

  Future<void> getSelections () async {
    CollectionReference selectionsRef = FirebaseFirestore.instance.collection("selections");
    QuerySnapshot snapshot = await selectionsRef.where("parent", isEqualTo: id).limit(10).get();
    if (selections == null) {
      selections = [];
    }
    for (int i = 0; i < snapshot.docs.length; i++) {
      selections!.add(OrderItem(
        id: snapshot.docs[i].id,
        itemId: snapshot.docs[i]["item"],
        quantity: snapshot.docs[i]["quantity"],
        size: snapshot.docs[i]["size"],
      ));
    }
    for (int i = 0; i < selections!.length; i++) {
      await selections![i].getItemData();
      await selections![i].item!.getSale();
    }
  }

  void setOrderItems (List<OrderItem> data) {
    selections = data;
  }

  void addOrderItem (OrderItem data) {
    if (selections == null) {
      selections = [];
    }
    selections!.add(data);
  }

  void removeOrderItem (OrderItem data) {
    selections?.remove(data);
    selectionIds?.remove(data.id);
  }

  void setItemIDs (List<String> data) {
    selectionIds = data;
  }

  void setReturnData (List<ReturnData> data) {
    returns = data;
  }

  void addReturnData (ReturnData data) {
    if (returns == null) {
      returns = [];
    }
    if (returnIds == null) {
      returnIds = [];
    }
    returns!.add(data);
    returnIds!.add(data.id);
  }

  void setReturnIDs (List<String> data) {
    returnIds = data;
  }
}

class ReturnData {
  String id;
  String reason;
  OrderItem? selection;
  String oid;
  int returnDate;
  String status;
  ReturnData({this.id="", this.reason="", this.selection, this.oid="", this.returnDate=0, this.status=""});

  Future<void> getSelection () async {
    CollectionReference selectionsRef = FirebaseFirestore.instance.collection("selections");
    QuerySnapshot snapshot = await selectionsRef.where("parent", isEqualTo: id).get();

    selection = OrderItem(
      id: snapshot.docs[0].id,
      itemId: snapshot.docs[0]["item"],
      quantity: snapshot.docs[0]["quantity"],
      size: snapshot.docs[0]["size"],
    );

    await selection!.getItemData();
    await selection!.item!.getSale();
  }

  void setReturnItem (OrderItem data) {
    selection = data;
  }
}

class OrderItem {
  String id;
  String itemId;
  ItemData? item;
  Sale? sale;
  String saleID;
  String size;
  int quantity;
  OrderItem({this.id="", this.itemId="", this.item, this.size="", this.quantity=0, this.sale, this.saleID=""});

  void setItem (ItemData data) {
    item = data;
  }

  void setSale (Sale data) {
    sale = data;
  }

  Future<void> getItemData () async {
    CollectionReference items = FirebaseFirestore.instance.collection('items');
    DocumentSnapshot snapshot = await items.doc(itemId).get();
    item = ItemData(
      id: snapshot.id,
      name: snapshot["name"],
      brand: snapshot["brand"],
      availableNumber: snapshot["availableNumber"],
      availableSizes: snapshot["sizes"].cast<String>(),
      price: snapshot["price"],
      description: snapshot["description"],
      saleID: snapshot["sale"],
      sku: snapshot["sku"],
      madeIn: snapshot["madeIn"],
    );
    //do something
  }

  Future<void> getSale () async {
    CollectionReference sales = FirebaseFirestore.instance.collection('sales');
    DocumentSnapshot snapshot = await sales.doc(saleID).get();
    sale = Sale(snapshot.id, snapshot["name"], snapshot["value"]);
  }
}