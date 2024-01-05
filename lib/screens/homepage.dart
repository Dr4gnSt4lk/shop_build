import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_build/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkbgColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            surfaceTintColor: darkbgColor,
            backgroundColor: bgColor,
            title: Text(
              'Главная',
              style: TextStyle(color: selectColor, fontSize: 25),
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
                              hintText: "Поиск",
                              hintStyle: TextStyle(
                                  color: Color(0xFAFAFAFF), fontSize: 19),
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
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item ${index + 1}'),
                );
              },
              childCount: 50,
            ),
          ),
        ],
      ),
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
