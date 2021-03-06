import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Data/Brand.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen/BrowseItemTile.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen/TodayItemTile.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomInnerShadow.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:luxury_app_pre/Widget/CustomRoundTextButton.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen/BrandTile.dart';
import 'package:luxury_app_pre/Widget/SearchBar.dart';
//import 'package:luxury_app_pre/Widget/CustomScrollIndicator.dart';

class BrowseScreen extends StatefulWidget {

  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final PageController pageControl = PageController();
  final CarouselController brandControl = CarouselController();
  late Future initialised;

  @override
  void initState () {
    super.initState();
    initialised = Future.wait([utils.dataManager.getItemData(), utils.dataManager.getCartData()]);
  }

  Widget build (BuildContext context) {
    return FutureBuilder(
      future: initialised,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildPage(context);
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildPage (BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height - 10,
            child: Container(
              height: MediaQuery.of(context).size.height - 10,
              child: buildColumn(context),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: (utils.appManager.loggedIn) ? buildButtons(context) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColumn (BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text("????????? ?????????", style: utils.resourceManager.textStyles.base18_100,),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          //child: SearchBar(),
        ),
        Container(
          height: MediaQuery.of(context).size.width*(2/3),
          child: buildBrands(),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text("????????? ?????????", style: utils.resourceManager.textStyles.base18_100,),
        ),
        CustomCrossDivider(),
        Container(
          child: buildTodayProduct(),
        ),
        CustomCrossDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text("?????? ?????????", style: utils.resourceManager.textStyles.base18_100,),
        ),
        Container(
          child: Container(
            child: buildGridView(context),
          ),
        ),
        Container(
          height: 20,
        ),
        CustomThreeCrossDivider(),
      ],
    );
  }

  Widget buildBrands () {
    return CarouselSlider.builder(
      carouselController: brandControl,
      itemCount: utils.dataManager.brands!.length,
      itemBuilder: (context, index, realIndex) {
        return BrandTile(utils.dataManager.brands![index]);
      },
      options: CarouselOptions(
        viewportFraction: 0.5,
        initialPage: 0,
        enableInfiniteScroll: true,
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }

  Widget buildTodayProduct () {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TodayItemTile(utils.dataManager.items![0]),
    );
  }

  Widget buildGridView (BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: ((utils.dataManager.items!.length - 1)~/2),
      itemBuilder: (context, index) {
        return Column(
          children: [
            CustomThreeCrossDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                  child: BrowseItemTile(utils.dataManager.items![2*index + 1]),
                ),
                (2*index + 2 < utils.dataManager.items!.length) ? Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                  child: BrowseItemTile(utils.dataManager.items![2*index + 2]),
                ) : Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildButtons (BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder(
            valueListenable: utils.dataManager.user!.cart.cartLength,
            builder: (context, String value, child) {
              return Container(
                key: Key("CartButton2" + value),
                child: CustomRoundTextButton(
                  whenPressed: () {
                    utils.appManager.toShoppingPage(context, utils.pageNav);
                  },
                  text: value,
                  style: utils.resourceManager.textStyles.dots,
                  w: 50,
                  h: 50,
                ),
              );
            },
            child: Container(),
          ),
        ],
      ),
    );
  }
}