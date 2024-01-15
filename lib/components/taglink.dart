import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_build/constants.dart';

Widget tagLink(String picture, String name) => Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: selectColor))),
      child: Row(children: [
        Container(
          height: 70,
          width: 73,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 12, left: 16, top: 12, right: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 3, color: selectColor),
              borderRadius: BorderRadius.circular(12)),
          child: SvgPicture.asset(picture),
        ),
        Expanded(
            child: AutoSizeText(
          name,
          style: TextStyle(
              color: selectColor, fontSize: 17, fontWeight: FontWeight.bold),
        )),
        Container(
            child: Center(
                widthFactor: 4.6,
                child: SvgPicture.asset(
                  'icons/Arrow.svg',
                  height: 25,
                  color: selectColor,
                )))
      ]),
    );
