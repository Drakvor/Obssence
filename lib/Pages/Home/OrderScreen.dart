import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/OrderScreen/OrderListItem.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class OrderScreen extends StatefulWidget {

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future initialised;

  void setPageState () {
    setState(() {
      //do nothing
    });
  }

  @override
  void initState () {
    super.initState();
    initialised = utils.dataManager.getOrderData();
  }

  Widget build(BuildContext context) {
    CollectionReference orders = FirebaseFirestore.instance.collection('orders');

    return FutureBuilder(
      future: initialised,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildFramework();
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildFramework () {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: mainHeader(),
                ),
                Expanded(
                  child: mainColumn(),
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainHeader () {
    return Container(
      height: 50,
      child: Stack(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("주문목록", style: utils.resourceManager.textStyles.base15_700,),
                //plus button
              ],
            ),
          ),
          Positioned(
            left: 5,
            top: 5,
            width: 40,
            height: 40,
            child: CustomRoundButton(
              whenPressed: () {
                utils.appManager.previousPage(utils.pageNav);
              },
              image: utils.resourceManager.images.backButton,
              imagePressed: utils.resourceManager.images.backButton,
              h: 40,
              w: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget mainColumn () {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: utils.dataManager.user!.orders.listOrders.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: getSelections(utils.dataManager.user!.orders.listOrders[index]),
          ),
        );
      },
    );
  }

  List<Widget> getSelections (OrderData order) {
    List<Widget> elements = [];
    elements.add(
      Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text("주문 일자: " + order.orderDate.toString().substring(6, 8) + "." + order.orderDate.toString().substring(4, 6) + "." + order.orderDate.toString().substring(2, 4), style: utils.resourceManager.textStyles.base14_700,),
            ),
            CustomButton(
              whenPressed: () {
                utils.appManager.toOrderDetailsPage(context, utils.pageNav, order);
              },
              text: "주문번호: " + order.oid.toString(),
              style: utils.resourceManager.textStyles.base12_100,
              h: 25,
              w: 180,
            ),
          ],
        ),
      ),
    ); //header with date and stuff
    for (int i = 0; i < order.selections!.length; i++) {
      elements.add(CustomThinDivider());
      elements.add(OrderListItem(setPageState, order.selections![i]));
    }
    elements.add(CustomThinDivider());
    elements.add(Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            whenPressed: () {
              utils.appManager.toOrderEditPage(context, utils.pageNav, order);
            },
            text: "교환, 반품 신청",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 120,
          ),
        ]
      ),
    ));
    elements.add(CustomDivider());
    return elements;
  }

  Widget mainFooter () {
    return Container();
  }
}
