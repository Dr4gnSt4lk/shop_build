import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_build/components/taglink.dart';
import 'package:shop_build/constants.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkbgColor,
      body: ColorfulSafeArea(
          color: bgColor,
          child: CustomScrollView(slivers: <Widget>[
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
                children: [
                  InkWell(
                    child: tagLink('icons/Bear.svg', 'Большие игрушки'),
                    onTap: () {
                      context.goNamed('Search');
                    },
                  ),
                  InkWell(
                    child: tagLink('icons/Ball.svg', 'Круглые игрушки'),
                    onTap: () {
                      context.goNamed('Search');
                    },
                  ),
                  InkWell(
                    child: tagLink('icons/Cat.svg', 'Объёмные игрушки'),
                    onTap: () {
                      context.goNamed('Search');
                    },
                  ),
                  InkWell(
                    child: tagLink('icons/Bird.svg', 'Маленькие игрушки'),
                    onTap: () {
                      context.goNamed('Search');
                    },
                  ),
                  InkWell(
                    child: tagLink('icons/Croco.svg', 'Смешные игрушки'),
                    onTap: () {
                      context.goNamed('Search');
                    },
                  ),
                  InkWell(
                    child: tagLink('icons/Dog.svg', 'Сезонные игрушки'),
                    onTap: () {
                      context.goNamed('Search');
                    },
                  ),
                ],
              ),
            )
          ])),
    );
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
