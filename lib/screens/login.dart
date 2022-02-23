import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pizzadym_deliveryman/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вход для сотрудников'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Введите Ваш Email';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email адрес',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Введите пароль';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    labelText: 'Пароль',
                    border: const OutlineInputBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await _auth.signInWithEmailAndPassword(
                              email: _emailController.text.toLowerCase(),
                              password: _passwordController.text,
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                reUsableSnackBar(
                                  'Сотрудник с таким имейлом не зарегестрирован!',
                                  context,
                                ),
                              );
                            } else if (e.code == 'wrong-password') {
                              debugPrint('Не правильный пароль');
                              ScaffoldMessenger.of(context).showSnackBar(
                                reUsableSnackBar(
                                  'Введен неверный пароль!',
                                  context,
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text('Войти'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
