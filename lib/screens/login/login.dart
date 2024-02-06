import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_build/constants.dart';
import 'package:shop_build/sql_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkbgColor,
        body: ColorfulSafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Text(
                    'Test Task',
                    style: TextStyle(
                        color: selectColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, left: 28),
                child: Text(
                  'Войти в свой Аккаунт',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                  height: 74,
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: bgColor,
                      elevation: 10,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            contentPadding: EdgeInsets.only(left: 12)),
                      ))),
              Container(
                  height: 74,
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: bgColor,
                      elevation: 10,
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Пароль',
                            contentPadding: EdgeInsets.only(left: 12)),
                      ))),
              Container(
                  height: 74,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                  margin: EdgeInsets.only(top: 15),
                  child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: elementColor,
                      elevation: 10,
                      child: InkWell(
                        child: Center(
                          child: Container(
                            child: Text(
                              'Войти',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () async {
                          bool isAuthenticated =
                              await SQLHelper.authenticateUser(
                                  emailController.text,
                                  passwordController.text);
                          if (isAuthenticated) {
                            print(
                                'Пользователь успешно авторизован. Имя пользователя: ${SQLHelper.customer}');
                            context.goNamed('Home');
                          } else {
                            print('Неверный email или пароль');
                          }
                        },
                      ))),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: Text('- Войти с помощью -')),
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 8),
                      child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: elementColor,
                          elevation: 10,
                          child: InkWell(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset('icons/Google.svg'),
                                height: 50,
                              ),
                            ),
                            onTap: () {
                              loginUserWithGoogle(context);
                            },
                          ))),
                  SizedBox(width: 12),
                  Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 8),
                      child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: elementColor,
                          elevation: 10,
                          child: InkWell(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(),
                                child: SvgPicture.asset(
                                  'icons/Vk.svg',
                                  height: 38,
                                ),
                                height: 50,
                              ),
                            ),
                            onTap: () {},
                          ))),
                ],
              )),
              Container(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Еще нет аккаунта?'),
                            SizedBox(width: 2),
                            GestureDetector(
                              child: Text(
                                'Регистрация',
                                style: TextStyle(
                                    color: selectColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                context.goNamed('Register');
                              },
                            )
                          ])))
            ],
          ),
        )));
  }
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
