import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/PaymentScreen/ReservationState.dart';

class ReservationTimes extends StatefulWidget {
  final Function changeState;
  final ReservationState state;
  ReservationTimes(this.changeState, this.state);

  @override
  _ReservationTimesState createState() => _ReservationTimesState(changeState, state);
}

class _ReservationTimesState extends State<ReservationTimes> {
  Function changeState;
  ReservationState state;
  _ReservationTimesState(this.changeState, this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      child: buildTimes(),
    );
  }

  Widget buildTimes () {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return buildButton(index);
      },
    );
  }

  Widget buildButton (int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          state.setDate(index + 10);
          state.nextState();
          changeState();
        });
      },
      child: Container(
        height: 35,
        width: 35,
        child: Stack(
          children: [
            Center(
              child: buttonImage(index + 10),
            ),
            Center(
              child: Container(
                height: 20,
                width: 20,
                child: Center(
                  child: Text((index + 10).toString()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonImage (int index) {
    return Container(
      height: 35,
      width: 35,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: (index == state.time) ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
      ),
    );
  }
}
