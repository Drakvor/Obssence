import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:luxury_app_pre/Pages/Home/OrderScreen/OrderListItem.dart';

import 'ReturnsScreen/ReturnsListItem.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderData order;
  OrderDetailsScreen(this.order);

  Future<void> finishDataAccess () async {
    for (int i = 0; i < order.returns!.length; i++) {
      await order.returns![i].getSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference returns = FirebaseFirestore.instance.collection("returns");

    return FutureBuilder(
      future: returns.where("parent", isEqualTo: order.id).get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          List<ReturnData> returnList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            ReturnData newReturn = new ReturnData(
              id: snapshot.data!.docs[i]["id"],
              reason: snapshot.data!.docs[i]["reason"],
              returnDate: snapshot.data!.docs[i]["returnDate"],
            );
            returnList.add(newReturn);
          }
          order.setReturnData(returnList);

          return FutureBuilder(
            future: finishDataAccess(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return  buildFramework(context);
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildFramework (BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                getHeader(context),
                CustomDivider(),
                Expanded(
                  child: getMainColumn(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getHeader (BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          child: Stack(
            children: [
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("????????????", style: utils.resourceManager.textStyles.base15_700,),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                width: 50,
                height: 50,
                child: CustomRoundButton(
                  whenPressed: () {
                    utils.appManager.previousPage(utils.pageNav);
                  },
                  image: utils.resourceManager.images.backButton,
                  imagePressed: utils.resourceManager.images.backButton,
                  h: 50,
                  w: 50,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("?????? ??????: " + order.orderDate.toString().substring(6, 8) + "." + order.orderDate.toString().substring(4, 6) + "." + order.orderDate.toString().substring(2, 4), style: utils.resourceManager.textStyles.base14_700),
              Text("????????????: " + order.oid, style: utils.resourceManager.textStyles.base12_100),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMainColumn (BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text("????????????", style: utils.resourceManager.textStyles.base14_700),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("?????? ??????", style: utils.resourceManager.textStyles.base13_100),
              Text("???9,992,350,000", style: utils.resourceManager.textStyles.base13_100),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("?????????", style: utils.resourceManager.textStyles.base13_100),
              Text("?????????", style: utils.resourceManager.textStyles.base13_100),
            ],
          ),
        ),
        CustomThinDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("??? ????????????", style: utils.resourceManager.textStyles.baseBold),
              Text("???9,992,350,000", style: utils.resourceManager.textStyles.baseBold),
            ],
          ),
        ),
        CustomDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text("????????????", style: utils.resourceManager.textStyles.base14_700),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text(utils.dataManager.user!.firstName + " " + utils.dataManager.user!.lastName, style: utils.resourceManager.textStyles.base13_100),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Text("(13588) ????????? ????????? ????????? ????????? 91 ????????????????????? 327??? 1309???", style: utils.resourceManager.textStyles.base13_100),
        ),
        CustomDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text("????????????", style: utils.resourceManager.textStyles.base14_700),
        ),
        Container(
          child: Column(
            children: getSelections(),
          ),
        ),
        CustomDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text("??????, ????????? ??????", style: utils.resourceManager.textStyles.base14_700),
        ),
        Container(
          child: Column(
            children: getReturns(context),
          ),
        ),
      ],
    );
  }

  List<Widget> getSelections () {
    List<Widget> elements = [];
    for (int i = 0; i < order.selections!.length; i++) {
      elements.add(OrderListItem(() {}, order.selections![i]));
    }
    return elements;
  }

  List<Widget> getReturns (BuildContext context) {
    List<Widget> elements = [];
    for (int i = 0; i < order.returns!.length; i++) {
      elements.add(ReturnsListItem(() {}, order.returns![i]));
      elements.add(CustomThinDivider());
    }
    return elements;
  }
}
