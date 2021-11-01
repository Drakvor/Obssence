import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/OrderEditState.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';

class MethodSelectionList extends StatefulWidget {
  final OrderEditState state;
  MethodSelectionList(this.state);

  @override
  _MethodSelectionListState createState() => _MethodSelectionListState(state);
}

class _MethodSelectionListState extends State<MethodSelectionList> {
  OrderEditState state;
  _MethodSelectionListState(this.state);

  List<String> methods = ["반품", "교환"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDivider(),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
            child: Text("어떤 해결 방법을 원하세요?", style: utils.resourceManager.textStyles.base14_700,),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(methods[0], style: utils.resourceManager.textStyles.base14,),
                Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        state.setMethod(methods[0]);
                        state.changeState!();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Stack(
                          children: [
                            (state.method == methods[0]) ? buttonPressed() : buttonUnpressed(),
                            Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset(utils.resourceManager.images.backButton),
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
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(methods[1], style: utils.resourceManager.textStyles.base14,),
                Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        state.setMethod(methods[1]);
                        state.changeState!();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Stack(
                          children: [
                            (state.method == methods[1]) ? buttonPressed() : buttonUnpressed(),
                            Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset(utils.resourceManager.images.backButton),
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
        ],
      ),
    );
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
}
