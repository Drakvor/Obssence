import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class TermsConditionsScreen extends StatelessWidget {
  String text = """각 이를 서비스 홈페이지에 게시하거나 회원에게 전자적 형태(이메일, 이메일 주소가 없는 경우 서비스 내 전자쪽지 발송, 서비스 내 알림 메시지를 띄우는 등의 별도의 전자적 수단 , 'OBSSENCE' 서비스에 등록한 휴대폰번호로 SMS 발송 등)로 약관 개정 사실을 발송하여 안내 드리겠습니다.

  회사가 회원에게 약관 개정 사실을 공지하거나 통지하면서 공지 또는 통지ㆍ고지일로부터 개정약관 시행일까지 거부의사를 표시하지 아니하면 승인한 것으로 본다는 뜻을 명확하게 고지하였음에도 불구하고 회원이 명시적으로 거부의사를 표시하지 않거나 탈퇴하지 않으면 그 회원은 개정약관에 정한 모든 내용에 대하여 동의한 것으로 간주됩니다.

  여러분은 변경된 약관에 대하여 거부의사를 표시함으로써 이용계약의 해지를 선택할 수 있습니다.

  회원은 서비스의 화면에서 본 약관의 내용을 확인할 의무가 있으며, 개정된 약관에 동의한 회원이 약관의 변경으로 인하여 입은 피해 및 회원의 확인 소홀로 개정된 약관의 내용을 알지 못해 발생하는 피해에 대해서 회사는 책임지지 않습니다.

  **제 3 조 (약관 외 준칙)**

  '회사'는 서비스 제공과 관련하여 별도의 이용약관 및 별도의 운영정책 및 규칙(이하 총치하여 '세부지침 등')을 둘 수 있으며, 해당 내용이 이 약관과 상충하는 경우에는 세부지침 등이 우선하여 적용됩니다.

  **제 4 조 (계약의 성립)**

  이용계약은 '회원'이 되고자 하는 자(이하 '가입신청자')가 서비스 화면에 게재된 SNS 배너 또는 ‘회원가""";

  @override
  Widget build (BuildContext context) {
    return buildScaffold();
  }

  Widget buildScaffold () {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                child: mainHeader(),
              ),
              CustomDivider(),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(text, style: utils.resourceManager.textStyles.base15,),
                    ),
                  ],
                ),
              ),
            ],
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
                Text("OBSSENCE 약관", style: utils.resourceManager.textStyles.base15_700,),
                //plus button
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
    );
  }
}
