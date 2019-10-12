import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final batch = TextEditingController(), pass = TextEditingController();
  List data;
  String api = "testapi";
  bool auth = false;
  @override
  String md5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  String apipresent() {
    return (api != null) ? "t" : "f";
  }

  Future<String> getData() async {
    var rn = new Random().nextInt(100).toString(), p = md5(pass.text);
    var response = await http.post(
        Uri.encodeFull(
            "http://192.168.1.216/sch/login.php"), //bkp "http://192.168.1.53:3002/lg/login"   for node js

        body: {
          'batch': batch.text,
          'pass': md5("$p" + "$rn"),
          'st': rn,
          'tst': apipresent().toString()
        });
    print(response.body);
    data = json.decode(response.body);
    print(data);
    Fluttertoast.showToast(
        msg: data.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SCE hub',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SCE HUB'),
        ),
        body: Form(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                  height: 70.0,
                  width: 210.0,
                  child: Text(
                    'Login nigga !',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                        fontSize: 25.0),
                  )),
            ),
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  controller: batch,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  // validator: ,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'Batch no',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                )),
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  obscureText: true,
                  controller: pass,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                )),
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                    width: 120.0,
                    height: 60.0,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: getData,
                      child: Text(
                        'login',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 18),
                      ),
                    )))
          ],
        ))),
      ),
    );
  }
}
