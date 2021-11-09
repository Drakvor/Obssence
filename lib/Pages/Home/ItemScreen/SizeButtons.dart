import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Pages/Home/ItemScreen/SelectionState.dart';

class SizeButtons extends StatefulWidget {
  final ItemData item;
  final SelectionState state;
  final List<String> sizes;
  SizeButtons(this.state, this.sizes, this.item);

  @override
  _SizeButtonsState createState() => _SizeButtonsState(state, sizes, item);
}

class _SizeButtonsState extends State<SizeButtons> {
  final ItemData item;
  final SelectionState state;
  final List<String> sizes;
  _SizeButtonsState(this.state, this.sizes, this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getButtons(),
    );
  }

  List<Widget> getButtons () {
    List<Widget> buttons = [];
    for (int i = 0; i < sizes.length; i++) {
      buttons.add(buildButton(i));
    }
    return buttons;
  }

  Widget buildButton (int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          state.setSize(index);
        });
      },
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            child: Stack(
              children: [
                buttonImage(index),
                Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Text(item.availableSizes![index].split(" ")[0], style: utils.resourceManager.textStyles.dots),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text("5 남음", style: TextStyle(fontSize: 10),),
          ),
        ],
      ),
    );
  }

  Widget buttonImage (int index) {
    return Container(
      height: 40,
      width: 40,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: (index == state.size) ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
      ),
    );
  }
}
