import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_build/constants.dart';

Widget tagCard(String picture, String name) => Row(children: [
      InkWell(
        child: Column(children: [
          Container(
            height: 75,
            width: 78,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 3, color: selectColor),
                borderRadius: BorderRadius.circular(12)),
            child: SvgPicture.asset(picture),
          ),
          Container(
            height: 34,
            width: 78,
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 14,
                  color: selectColor,
                  fontWeight: FontWeight.w500,
                  height: 1.15),
              textAlign: TextAlign.center,
            ),
          )
        ]),
        onTap: () {},
      ),
      SizedBox(
        width: 15,
      )
    ]);
