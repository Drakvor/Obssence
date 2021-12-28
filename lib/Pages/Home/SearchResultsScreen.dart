import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen/BrowseItemTile.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:path_provider/path_provider.dart';

class SearchResultsScreen extends StatefulWidget {

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ScrollController scrollControl = new ScrollController();

  void listen () {
    if (scrollControl.offset >= scrollControl.position.maxScrollExtent) {
      utils.appManager.loadOverlay!(200, buildRecommend());
      utils.appManager.overlayCont.animateTo(
          1, duration: Duration(milliseconds: 150), curve: Curves.linear);
    }
  }

  @override
  void initState () {
    super.initState();
    scrollControl.addListener(listen);
  }

  void dispose () {
    scrollControl.removeListener(listen);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
      body: Stack(
        children: [
          Column(
            children: [
              buildHeader(),
              CustomDivider(),
              Expanded(
                child: buildGridView(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Stack(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("검색 결과", style: utils.resourceManager.textStyles.base15,),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            height: 50,
            width: 50,
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
    );
  }

  Widget buildGridView (BuildContext context) {
    if (utils.dataManager.items!.length == 0) {
      return Container(
        child: Center(
          child: Text("검색 결과가 없습니다.", style: utils.resourceManager.textStyles.base14_700,),
        ),
      );
    }
    return ListView.builder(
      controller: scrollControl,
      cacheExtent: utils.dataManager.items!.length.toDouble(),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: ((utils.dataManager.items!.length)~/2),
      itemBuilder: (context, index) {
        return Column(
          children: [
            (index == 0) ? Container(height: 20,) : Container(height: 0,),
            CustomThreeCrossDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                  child: BrowseItemTile(utils.dataManager.items![2*index]),
                ),
                (2*index + 1 < utils.dataManager.items!.length) ? Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                  child: BrowseItemTile(utils.dataManager.items![2*index + 1]),
                ) : Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                ),
              ],
            ),
            (index == ((utils.dataManager.items!.length)~/2) - 1) ? CustomThreeCrossDivider() : Container(height: 0,),
            (index == ((utils.dataManager.items!.length)~/2) - 1) ? Container(height: 20,) : Container(height: 0,),
          ],
        );
      },
    );
  }

  Widget buildRecommend () {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("새로 나온 바지를 보고 싶으신가요?"),
                CustomButton(
                  whenPressed: () async {
                    late List<File> images;
                    images = await initTile();
                    await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 150), curve: Curves.linear);
                    utils.appManager.toItemPage(context, utils.pageNav, utils.dataManager.items![0], images);
                  },
                  text: "보러가기",
                  style: utils.resourceManager.textStyles.base14,
                  w: 100,
                  h: 30,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            width: 50,
            height: 50,
            child: Container(
              child: Center(
                child: Lottie.asset(utils.resourceManager.jsons.heartAnimation,
                  width: 42,
                  height: 42,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<File>> initTile () async {
    List<File> imagesSaved = [];
    ListResult results = await FirebaseStorage.instance.ref().child("Items").child(utils.dataManager.items![0].id).listAll();
    Directory appImgDir = await getApplicationDocumentsDirectory();
    for (int i = 0; i < results.items.length; i++) {
      File image = File('${appImgDir.path}/' + utils.dataManager.items![0].id + results.items[i].name);
      if (!image.existsSync()) {
        print("Getting");
        await FirebaseStorage.instance
            .ref(results.items[i].fullPath)
            .writeToFile(image);
      }
      imagesSaved.add(image);
    }
    return imagesSaved;
  }
}
