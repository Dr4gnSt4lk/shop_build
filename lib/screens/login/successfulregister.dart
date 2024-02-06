import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants.dart';

class SuccessfulRegister extends StatelessWidget {
  const SuccessfulRegister({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () => context.goNamed('Home'));

    return Scaffold(
        backgroundColor: elementColor,
        body: Center(
            child: Text(
          'Регистрация успешна',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        )));
  }
}
