import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sample_02_sqlite/db/contact_db.dart';
import 'package:flutter_sample_02_sqlite/db/contact.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method


class ViewInfo extends StatelessWidget {
  ViewInfo({Key? key, required this.id}) : super(key: key);

  final String id;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  //String name = '';
  //String phone = '';

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
        body: loadBuilder()
    );
  }

  Future<List<Contact>> loadContact(String id) async{
    /*List<Widget> memoList = [;
    memoList.add(Container(color: Colors.purple, height: 100,));
    memoList.add(Container(color: Colors.red, height: 100,));
    return memoList;*/
    DBHelper sd = DBHelper();
    return await sd.ContactsId(id);
  }

  Future<void> savdDB(BuildContext buildContext) async{
    DBHelper sd = DBHelper();

    var fido = Contact(id: id , name: _nameController.text , phone: _phoneController.text , editTime: DateTime.now().toString());
    await sd.updateContact(fido);

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

  Future<void> deleteContact(String id) async{
    /*List<Widget> memoList = [];
    memoList.add(Container(color: Colors.purple, height: 100,));
    memoList.add(Container(color: Colors.red, height: 100,));
    return memoList;*/
    DBHelper sd = DBHelper();
    return await sd.deleteContact(id);
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 경고'),
          content: Text("정말 삭제? \n 복구안돼."),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
                deleteContact(id);
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

  loadBuilder(){
    return FutureBuilder<List<Contact>>(
      future: loadContact(id),
      builder: (context, projectSnap) {
        if(projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null || projectSnap.data == null){
          return Container(
            child : Text("데이터 없음"),
          );
        }else{
          Contact contact = projectSnap.data![0];
          // 데이터를 가져온 후 _nameController와 _phoneController를 통해 TextField에 값을 설정
          _nameController.text = contact.name;
          _phoneController.text = contact.phone;

          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController, // _nameController 사용
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: '이름을 작성해주세요.',
                      prefixIcon: Icon(Icons.person),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextField(
                  controller: _phoneController, // _phoneController 사용
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: '전화번호를 넣어주세요.',
                      prefixIcon: Icon(Icons.phone)
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }



  /*Future<void> savdDB(BuildContext buildContext) async{
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
  }*/
}
