import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gee/pages/home_page.dart';
import 'package:gee/utils/appPrefences.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool onRequest = false;
  TextEditingController kullaniciMailKontrolcusu = TextEditingController();
  TextEditingController kullaniciSifreKontrolcusu = TextEditingController();

  @override
  void initState() {
    super.initState();
  } //Sayfa açıldıkdan sonra bura çalışır

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 15, left: 15), //Sağdan, soldan ve üstden 10 pixel boşluk bırak
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Hoşgeldin",
                    style: TextStyle(fontSize: 36, fontFamily: "Montserrat"),
                  ),
                  Padding(
                    child: Text(
                      "Devam Etmek İçin Giriş Yap",
                      style: TextStyle(fontSize: 14, fontFamily: "Montserrat"),
                    ),
                    padding: EdgeInsets.only(top: 22),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Burası boş bırakılamaz';
                        }
                        return null;
                      },
                      controller: kullaniciMailKontrolcusu, //Kullanıcının yazdığı şifreyi kontrol etmek için bunu kullanıyoruz
                      decoration: InputDecoration(labelText: "Kullanıcı Mail"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Burası boş bırakılamaz';
                        }
                        return null;
                      },
                      obscureText: true, //Yazı gizlensin mi
                      obscuringCharacter: "*", //şifreyi gizleyecek karakter *****
                      controller: kullaniciSifreKontrolcusu, //Kullanıcının yazdığı şifreyi kontrol etmek için bunu kullanıyoruz
                      decoration: InputDecoration(labelText: "Kullanıcı Şifresi"),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Color.fromRGBO(158, 1, 49, 1)),
                    onPressed: onRequest
                        ? null
                        : () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                onRequest = true;
                              });
                              final response = await http.post('https://gonulluesit.herokuapp.com/login',
                                  body: jsonEncode(
                                    <String, dynamic>{
                                      'mail': kullaniciMailKontrolcusu.text,
                                      'password': kullaniciSifreKontrolcusu.text,
                                    },
                                  ),
                                  headers: {
                                    'Content-type': 'application/json',
                                    'Accept': 'application/json',
                                  });
                              try {
                                var data = jsonDecode(response.body);
                                if (response.statusCode == 200) {
                                  appPrefences.setString("mail", kullaniciMailKontrolcusu.text);
                                  appPrefences.setString("pass", kullaniciSifreKontrolcusu.text);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(data["code"].toString()),
                                  ));
                                  Timer(Duration(seconds: 1), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  });
                                } else {
                                  Timer(Duration(seconds: 1), () {
                                    setState(() {
                                      onRequest = false;
                                    });
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(data["code"].toString()),
                                  ));
                                }
                              } catch (_) {
                                Timer(Duration(seconds: 1), () {
                                  setState(() {
                                    onRequest = false;
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Sunucu hatası, bağlantı başarısız"),
                                ));
                              }
                            }
                            /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                      */
                          },
                    icon: Icon(Icons.login, size: 12),
                    label: Text("Giriş Yap", style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Veya",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Color.fromRGBO(100, 100, 100, 1),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Color.fromRGBO(158, 1, 49, 1)),
                    onPressed: onRequest
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                    icon: Icon(Icons.app_registration, size: 12),
                    label: Text("Kayıt ol", style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
