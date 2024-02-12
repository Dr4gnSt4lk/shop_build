import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_build/constants.dart';
import 'package:shop_build/screens/login/successfulregister.dart';
import 'package:shop_build/sql_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkbgColor,
        body: ColorfulSafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  onPressed: () => {GoRouter.of(context).pop()},
                  icon: Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(
                        'icons/Marker.svg',
                        color: darkelementColor,
                        height: 32,
                      ))),
              Container(
                margin: EdgeInsets.only(top: 10, left: 28),
                child: Text(
                  'Регистрация Аккаунта',
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
                        controller: nameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Имя',
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
                        controller: confirmpasswordController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Подтвердите пароль',
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
                              'Регистрация',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (passwordController.text !=
                              confirmpasswordController.text) {
                            print('Пароли не совпадают');
                          } else {
                            await SQLHelper.registerUser(nameController.text,
                                passwordController.text, emailController.text);
                            bool isAuthenticated =
                                await SQLHelper.authenticateUser(
                                    emailController.text,
                                    passwordController.text);
                            if (isAuthenticated) {
                              print(
                                  'Пользователь успешно авторизован. Имя пользователя: ${SQLHelper.customer}');
                            }
                            context.goNamed('SuccessReg');
                          }
                        },
                      ))),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Center(child: Text('- Войти с помощью -')),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 15),
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
