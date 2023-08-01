import 'package:flutter/material.dart';
import 'package:flutter_sample_02_sqlite/db/contact_db.dart';
import 'package:flutter_sample_02_sqlite/db/contact.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method


class EditInfo extends StatelessWidget {

  String name = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(onPressed: () {
              showAlertDialog(context);
            }, icon: const Icon(Icons.delete)),
            IconButton(onPressed: () async {
              await savdDB(context);
            }, icon: const Icon(Icons.save)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '이름을 작성해주세요.',
                  prefixIcon: Icon(Icons.person)
                ),
                onChanged: (String name) {this.name = name;},
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '전화번호를 넣어주세요.',
                    prefixIcon: Icon(Icons.phone)
                ),
                onChanged: (String phone) {this.phone = phone;},
              ),
            ],
          ),
        )
    );
  }

  Future<void> savdDB(BuildContext buildContext) async{
    DBHelper sd = DBHelper();
    
    var fido = Contact(id: Str2Sha512(DateTime.now().toString()) , name: this.name, phone: this.phone, editTime: DateTime.now().toString());
    await sd.insertContact(fido);
    print(await sd.Contacts());

    if (await sd.Contacts() != null) {
      // 성공한 경우
      final snackBar = SnackBar(content: Text('성공했습니다.'));
      ScaffoldMessenger.of(buildContext).showSnackBar(snackBar);
      Navigator.pop(buildContext); // 뒤로가기
    } else {
      // 실패한 경우
      final snackBar = SnackBar(content: Text('실패했습니다.'));
      ScaffoldMessenger.of(buildContext).showSnackBar(snackBar);
    }
  }

  String Str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('취소'),
          content: Text("정말 취소? \n 복구안돼."),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }
}
