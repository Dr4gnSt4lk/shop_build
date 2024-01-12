import 'package:auto_size_text/auto_size_text.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_build/components/propcard.dart';
import 'package:shop_build/components/tagcart.dart';
import 'package:shop_build/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkbgColor,
        body: ColorfulSafeArea(
          color: bgColor,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                surfaceTintColor: darkbgColor,
                backgroundColor: bgColor,
                title: Text(
                  'Главная',
                  style: TextStyle(
                    color: selectColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 70.0,
                  maxHeight: 70.0,
                  child: Container(
                    color: bgColor,
                    child: Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, bottom: 5),
                        width: 310,
                        height: 55,
                        decoration: BoxDecoration(
                            color: elementColor,
                            border: Border.all(width: 3, color: selectColor),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            iconSize: 32,
                          ),
                          Container(
                              width: 100,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Поиск...",
                                  hintStyle: TextStyle(
                                      color: Color(0xFAFAFAFF),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5, left: 13),
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            color: elementColor,
                            border: Border.all(width: 3, color: selectColor),
                            borderRadius: BorderRadius.circular(12)),
                        child: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'icons/Notification.svg',
                              color: Colors.white,
                              height: 30,
                            )),
                      )
                    ]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 5),
                        child: Row(
                          children: [
                            tagCard('icons/Bear.svg', 'Большие игрушки'),
                            tagCard('icons/Ball.svg', 'Круглые игрушки'),
                            tagCard('icons/Cat.svg', 'Объёмные игрушки'),
                            tagCard('icons/Bird.svg', 'Маленькие игрушки'),
                            tagCard('icons/Croco.svg', 'Смешные игрушки'),
                            tagCard('icons/Dog.svg', 'Спокойные игрушки')
                          ],
                        )),
                    Container(
                        child: Row(
                      children: [
                        InkWell(
                          splashFactory: NoSplash.splashFactory,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(12, 12, 5, 0),
                            decoration: BoxDecoration(
                                color: elementColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(children: [
                              Container(
                                height: 35,
                                width: 32,
                                margin: EdgeInsets.fromLTRB(10, 10, 6, 10),
                                decoration: BoxDecoration(
                                    color: darkelementColor,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Icon(
                                  Icons.percent,
                                  color: Color(0xFAFAFAFF),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Скидки и акции',
                                    style: TextStyle(color: Color(0xFAFAFAFF)),
                                  ))
                            ]),
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          splashFactory: NoSplash.splashFactory,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(12, 12, 5, 0),
                            decoration: BoxDecoration(
                                color: elementColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(children: [
                              Container(
                                height: 35,
                                width: 32,
                                margin: EdgeInsets.fromLTRB(10, 10, 6, 10),
                                decoration: BoxDecoration(
                                    color: darkelementColor,
                                    borderRadius: BorderRadius.circular(3)),
                                child: Icon(
                                  Icons.list_alt,
                                  color: Color(0xFAFAFAFF),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Мои заказы',
                                    style: TextStyle(color: Color(0xFAFAFAFF)),
                                  ))
                            ]),
                          ),
                          onTap: () {},
                        )
                      ],
                    )),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.fromLTRB(12, 20, 12, 5),
                        child: Row(
                          children: [
                            propCard('icons/Bear.svg', 'Большой медведь', 5500,
                                6000, 5),
                            propCard('icons/Croco.svg', 'Смешной крокодил',
                                1250, 2000, 12),
                            propCard(
                                'icons/Cat.svg', 'Плюшевый кот', 3000, 3250, 7),
                            propCard(
                                'icons/Ball.svg', 'Мягкий мяч', 800, 900, 18)
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 8, bottom: 9),
                      child: Text(
                        'Новое в магазине',
                        style: TextStyle(
                            color: selectColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.64),
                itemCount: 8,
                itemBuilder: (context, index) => InkWell(
                    onTap: () {},
                    child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFA7CF9B),
                        ),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(9, 7, 9, 2),
                                child: Container(
                                    height: 145,
                                    width: 175,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xFF567B59),
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SvgPicture.asset('icons/Bear.svg'))),
                            Flexible(
                                child: Container(
                                    padding: EdgeInsets.only(left: 9, right: 9),
                                    margin: EdgeInsets.only(top: 1, bottom: 25),
                                    child: AutoSizeText(
                                        'Большой медведь ${index + 1}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFAFAFAFF),
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center))),
                            Padding(
                                padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
                                child: Flexible(
                                    child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFF567B59),
                                          width: 2)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 4, right: 10),
                                        child: Row(children: <Widget>[
                                          SvgPicture.asset('icons/Rating.svg',
                                              width: 30, height: 25),
                                          SvgPicture.asset('icons/Rating.svg',
                                              width: 30, height: 25),
                                          SvgPicture.asset('icons/Rating.svg',
                                              width: 30, height: 25),
                                          SvgPicture.asset('icons/Rating.svg',
                                              width: 30, height: 25),
                                          SvgPicture.asset('icons/Rating.svg',
                                              width: 30, height: 25)
                                        ]),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: Text(
                                          (500 + 10 * index).round().toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFAFAFAFF)),
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 8),
                                //height: 53,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF2FFEB),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: 7, top: 5),
                                                child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                      (5600 + 100 * index)
                                                              .toString() +
                                                          '₽',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xFF567B59)),
                                                    ))),
                                            Transform.translate(
                                                offset: Offset(0, -4),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 6, bottom: 3),
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                        'От ' +
                                                            ((500 + 100 * index) /
                                                                    12)
                                                                .round()
                                                                .toString() +
                                                            '₽/ в мес.',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Color(
                                                                0xFF567B59),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                ))
                                          ])),
                                      Container(
                                          child: IconButton(
                                              iconSize: 30,
                                              icon: Icon(
                                                Icons.info,
                                                color: Color(0xFFA7CF9B),
                                              ),
                                              onPressed: () {}))
                                    ]))
                          ],
                        ))),
              )
            ],
          ),
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
