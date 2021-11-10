import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/PaymentScreen/ReservationState.dart';

class ReservationCalendar extends StatefulWidget {
  final Function changeState;
  final ReservationState state;
  ReservationCalendar(this.changeState, this.state);

  @override
  _ReservationCalendarState createState() => _ReservationCalendarState(changeState, state);
}

class _ReservationCalendarState extends State<ReservationCalendar> {
  Function changeState;
  DateTime today = DateTime.now();
  ReservationState state;

  List<String> dayNames = ["월", "화", "수", "목", "금", "토", "일"];
  _ReservationCalendarState(this.changeState, this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: buildCalendar(),
    );
  }

  Widget buildCalendar () {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: 38,
      itemBuilder: (context, index) {
        if (index < 7) {
          return Center(
            child: Text(dayNames[index], style: utils.resourceManager.textStyles.base12_100,),
          );
        }
        return buildButton(index - 7);
      },
    );
  }

  Widget buildButton (int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          state.setDate(index + 1);
          changeState();
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          state.nextState();
          changeState();
        });
      },
      onTapCancel: () {
        setState(() {
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
              child: buttonImage(index + 1),
            ),
            Center(
              child: Container(
                height: 20,
                width: 20,
                child: Center(
                  child: Text((index + 1).toString(), style: utils.resourceManager.textStyles.dots10,),
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
        child: (index == state.date) ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
      ),
    );
  }
}
