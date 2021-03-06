import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomImage.dart';
import 'package:luxury_app_pre/Widget/CustomScrollIndicator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class TodayItemTile extends StatefulWidget {
  final ItemData item;
  TodayItemTile(this.item);

  @override
  _TodayItemTileState createState() => _TodayItemTileState(item);
}

class _TodayItemTileState extends State<TodayItemTile> {
  final PageController pageControl = new PageController();
  ItemData item;
  late List<File> images;
  late Directory appImgDir;
  int index = 0;
  late Future initialised;
  _TodayItemTileState(this.item);

  Future<void> initTile () async {
    List<File> imagesSaved = [];
    ListResult results = await FirebaseStorage.instance.ref().child("Items").child(item.id).listAll();
    appImgDir = await getApplicationDocumentsDirectory();
    for (int i = 0; i < results.items.length; i++) {
      File image = File('${appImgDir.path}/' + item.id + results.items[i].name);
      if (!image.existsSync()) {
        print("Getting");
        await FirebaseStorage.instance
            .ref(results.items[i].fullPath)
            .writeToFile(image);
      }
      imagesSaved.add(image);
    }
    images = imagesSaved;
  }

  void listen () {
    if (pageControl.page != null) {
      setState(() {
        index = (pageControl.page! + 0.5).toInt();
      });
    }
  }

  @override
  void initState () {
    super.initState();
    pageControl.addListener(listen);
    initialised = initTile();
  }

  void dispose () {
    pageControl.removeListener(listen);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialised,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              utils.appManager.toItemPage(context, utils.pageNav, item, images);
            },
            child: buildContents(),
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

  Widget buildContents () {
    return Container(
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Oct", style: utils.resourceManager.textStyles.base11_700,),
                      ),
                      Container(
                        child: Text("11", style: utils.resourceManager.textStyles.base16_800,),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(item.brand, style: utils.resourceManager.textStyles.base12_700U,),
                ),
                Container(
                  width: 50,
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: buildMain(),
          ),
          /**
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child: CustomButton(
                whenPressed: () {
                  utils.appManager.toItemPage(context, utils.pageNav, item, images, editing: true);
                },
                text: "????????? ??????",
                style: utils.resourceManager.textStyles.base14,
                w: 92,
                h: 22,
              ),
            ),
          ),**/
        ],
      ),
    );
  }

  Widget buildMain () {
    return Container(
      child: Stack(
        children: [
          Container(
          ),
          buildPageView(),
          Positioned(
            top: 1,
            left: 0,
            right: 0,
            height: 10,
            child: Container(
              child: Center(
                child: CustomScrollIndicator(index, images.length + 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView () {
    return PageView(
      controller: pageControl,
      physics: BouncingScrollPhysics(),
      children: getPages(),
    );
  }

  List<Widget> getPages () {
    List<Widget> pages = [];
    for (int i = 0; i < images.length + 1; i++) {
      if (i == 0) {
        pages.add(CustomImage(images[i]));
        //pages.add(Container(color: Color(0xffff9999),));
      }
      if (i == 1) {
        pages.add(
          Stack(
            children: [
              Center(
                child: CustomImage(images[0]),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 200,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: Container(
                        color: Color(0x55ffffff),
                        constraints: BoxConstraints.expand(),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.brand, style: utils.resourceManager.textStyles.base13_700U),
                              Container(
                                height: 20,
                              ),
                              Text(item.name, style: utils.resourceManager.textStyles.base12_100),
                              Container(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("???" + item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base12),
                                  Text(item.sale!.value.toString() + "%", style: utils.resourceManager.textStyles.base12),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      if (i > 1) {
        pages.add(CustomImage(images[i-1]));
        //pages.add(Container(color: Color(0xff9999ff),));
      }
    }
    return pages;
  }
}
