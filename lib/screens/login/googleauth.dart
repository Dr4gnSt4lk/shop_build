import 'package:flutter/material.dart';
import 'package:shop_build/sql_helper.dart';

class GoogleAuth extends StatelessWidget {
  const GoogleAuth({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Google Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            loginUserWithGoogle(context);
          },
          child: Text('Login with Google'),
        ),
      ),
    );
  }

  Future<void> loginUserWithGoogle(BuildContext context) async {
    try {
      // Вызов функции loginUserGoogle из QLHelper
      await SQLHelper.loginUserGoogle();

      // Дополнительная логика после успешного входа через Google, если необходимо

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Пользователь успешно вошел через google!'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ошибка: $error'),
      ));
    }
  }
}
