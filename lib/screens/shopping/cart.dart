import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_build/constants.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: ColorfulSafeArea(
            color: elementColor,
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                floating: true,
                surfaceTintColor: elementColor,
                backgroundColor: elementColor,
                title: Text(
                  'Корзина',
                  style: TextStyle(
                      color: Color(0xFAFAFAFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                      padding: EdgeInsets.only(left: 23, right: 23),
                      child: Center(
                        heightFactor: 4,
                        child: Column(children: [
                          Container(
                              child: Text(
                            'Корзина пока пустая',
                            style: TextStyle(
                                color: selectColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(height: 10),
                          Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'Воспользуйтесь популярными категориями или строкой поиска, чтобы исправить это',
                                style: TextStyle(
                                  color: selectColor,
                                ),
                                textAlign: TextAlign.center,
                              )),
                          SizedBox(height: 20),
                          InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: darkelementColor,
                                  border: Border.all(
                                      width: 3, color: darkelementColor),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                'Перейти к категориям',
                                style: TextStyle(
                                    color: Color(0xFAFAFAFF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              context.go('/tags');
                            },
                          )
                        ]),
                      )))
            ])));
  }
}
