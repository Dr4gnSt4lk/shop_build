import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_build/constants.dart';

Widget propCard(
        String picture, String name, int newPrice, int oldPrice, int hour) =>
    Row(children: [
      Container(
          width: 355,
          decoration: BoxDecoration(
              color: elementColor, borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: EdgeInsets.only(left: 18, top: 20),
                child: Text(
                  'Ещё $hour часов скидка',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                padding: EdgeInsets.only(left: 18, top: 4),
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            Container(
                padding: EdgeInsets.only(left: 18),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 20, right: 5),
                                    child: Text(
                                      newPrice.toString() + ' ₽',
                                      style: TextStyle(
                                        color: Color(0xFAFAFAFF),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(top: 22),
                                    child: Text(
                                      oldPrice.toString() + ' ₽',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.white70,
                                          decorationThickness: 2),
                                    ))
                              ],
                            ),
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(top: 7),
                                  height: 50,
                                  width: 135,
                                  decoration: BoxDecoration(
                                      color: darkelementColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                      child: Text(
                                    'Подробнее',
                                    style: TextStyle(
                                        color: Color(0xFAFAFAFF), fontSize: 18),
                                  ))),
                              onTap: () {},
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 110,
                        width: 110,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 15, right: 7, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 3, color: selectColor),
                            borderRadius: BorderRadius.circular(12)),
                        child: SvgPicture.asset(picture),
                      ),
                    ])),
          ])),
      SizedBox(
        width: 15,
      )
    ]);
