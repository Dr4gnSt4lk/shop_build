import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_build/constants.dart';
import 'package:shop_build/sql_helper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: ColorfulSafeArea(
            color: elementColor,
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                floating: true,
                surfaceTintColor: darkbgColor,
                backgroundColor: elementColor,
                title: Text(
                  'Профиль',
                  style: TextStyle(
                      color: Color(0xFAFAFAFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  Container(
                      margin: EdgeInsets.only(right: 6),
                      child: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'icons/Notification.svg',
                            color: Colors.white,
                            height: 30,
                          )))
                ],
              ),
              SliverToBoxAdapter(
                  child: Column(children: <Widget>[
                InkWell(
                    child: Container(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(18),
                            child: Icon(
                              Icons.account_circle,
                              color: elementColor,
                              size: 80,
                            )),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(top: 20, left: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: AutoSizeText(
                                    SQLHelper.customer,
                                    style: TextStyle(
                                        color: selectColor,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  child: Text(
                                    'TestTask@mail.ru',
                                    style: TextStyle(
                                        color: darkelementColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                )
                              ]),
                        )),
                        Container(
                            child: Center(
                          widthFactor: 3.83,
                          heightFactor: 4.5,
                          child: SvgPicture.asset(
                            'icons/Arrow.svg',
                            height: 25,
                            color: selectColor,
                          ),
                        ))
                      ],
                    )),
                    onTap: () {}),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Icon(
                          Icons.shopping_basket,
                          color: Color(0xFAFAFAFF),
                          size: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8, top: 20),
                            child: Text(
                              'Магазин по умолчанию',
                              style: TextStyle(
                                  color: Color(0xFAFAFAFF),
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Изначально устанавливаются при оформлении заказа',
                              style: TextStyle(
                                  color: Color(0xFAFAFAFF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ))
                    ]),
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: SvgPicture.asset(
                          'icons/Orders.svg',
                          color: Color(0xFAFAFAFF),
                          height: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              margin: EdgeInsets.only(left: 11, top: 20),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Заказы',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]))
                    ]),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Icon(
                          Icons.favorite,
                          color: Color(0xFAFAFAFF),
                          size: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              margin: EdgeInsets.only(left: 8, top: 22),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Избранное',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]))
                    ]),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Icon(
                          Icons.list_alt,
                          color: Color(0xFAFAFAFF),
                          size: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              margin: EdgeInsets.only(left: 8, top: 24),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Сравнение',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]))
                    ]),
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Icon(
                          Icons.help,
                          color: Color(0xFAFAFAFF),
                          size: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              margin: EdgeInsets.only(left: 8, top: 24),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Помощь',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]))
                    ]),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Icon(
                          Icons.info,
                          color: Color(0xFAFAFAFF),
                          size: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              margin: EdgeInsets.only(left: 8, top: 24),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'О приложении',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]))
                    ]),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    color: elementColor,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 20),
                        padding: EdgeInsets.only(bottom: 15),
                        child: Icon(
                          Icons.settings,
                          color: Color(0xFAFAFAFF),
                          size: 33,
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              margin: EdgeInsets.only(left: 8, top: 24),
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                'Настройки',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]))
                    ]),
                  ),
                  onTap: () {},
                ),
              ]))
            ])));
  }
}
