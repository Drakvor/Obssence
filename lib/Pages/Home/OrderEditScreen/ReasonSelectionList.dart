import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/OrderEditState.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomSearchBar.dart';

class ReasonSelectionList extends StatefulWidget {
  final OrderEditState state;
  ReasonSelectionList(this.state);

  @override
  _ReasonSelectionListState createState() => _ReasonSelectionListState(state);
}

class _ReasonSelectionListState extends State<ReasonSelectionList> {
  final OrderEditState state;
  final TextEditingController textControl = new TextEditingController();
  _ReasonSelectionListState(this.state);

  Map<String, List<String>> reasons = {
    "상품문제": ["상품이 파손됨", "상품이 설명과 다름", "주문한 상품과 다른 상품이 배송됨"],
    "배송문제": ["상품을 받지 못함", "배송된 장소에서 상품이 분실됨", "선택한 주소가 아닌 다른 주소로 배송됨"],
    "단순변심": ["상품 사이즈가 안맞음", "상품이 마음에 안듬", "가격 불만"],
    "기타": ["그 외 문제"],
  };
  List<String> reasonsIndex = ["상품문제", "배송문제", "단순변심", "기타"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: buildList()
        ),
        Container(
        ),
      ],
    );
  }

  Widget buildList () {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: reasonsIndex.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("어떤 문제가 있나요?", style: utils.resourceManager.textStyles.base14_700,),
          );
        }
        if (index == reasonsIndex.length + 1) {
          return buildTextField();
        }
        return Column(
          children: getReasons(index - 1),
        );
      }
    );
  }

  List<Widget> getReasons (int index) {
    List<Widget> reasonBlocks = [];
    reasonBlocks.add(
      Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Text(reasonsIndex[index], style: utils.resourceManager.textStyles.base12_100,),
      ),
    );
    for (int i = 0; i < reasons[reasonsIndex[index]]!.length; i++) {
      reasonBlocks.add(
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(reasons[reasonsIndex[index]]![i], style: utils.resourceManager.textStyles.base14,),
              Container(
                height: 50,
                width: 50,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      state.setReason(reasons[reasonsIndex[index]]![i]);
                      if (index == 3 && i == 0) {
                        state.setReason(textControl.text);
                      }
                      state.changeState!();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Stack(
                        children: [
                          (state.reason == reasons[reasonsIndex[index]]![i]) ? buttonPressed() : buttonUnpressed(),
                          Center(
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Image.asset(utils.resourceManager.images.downButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (index != 3) {
      reasonBlocks.add(
        CustomThinDivider(),
      );
    }
    return reasonBlocks;
  }

  Widget buttonPressed () {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButtonPressed),
        ),
      ),
    );
  }

  Widget buttonUnpressed () {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButton),
        ),
      ),
    );
  }

  Widget buildTextField () {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: CustomSearchBar(textControl, "*필수입력"),
    );
  }
}
