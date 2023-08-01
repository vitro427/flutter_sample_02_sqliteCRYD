import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample_02_sqlite/db/contact.dart';
import 'package:flutter_sample_02_sqlite/screens/edit.dart';
import 'package:flutter_sample_02_sqlite/db/contact_db.dart';
import 'package:flutter_sample_02_sqlite/screens/view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String deleteId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite sample'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: contactBuilder(context),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, CupertinoPageRoute(builder: (context) => EditInfo()));
        },
        tooltip: '메모를 추가하려면 클릭하세요',
        icon: Icon(Icons.add),
        label: Text('메모 추가'),
      ),
    );
  }

  Future<List<Contact>> loadContact() async{
    /*List<Widget> memoList = [;
    memoList.add(Container(color: Colors.purple, height: 100,));
    memoList.add(Container(color: Colors.red, height: 100,));
    return memoList;*/
    DBHelper sd = DBHelper();
    return await sd.Contacts();
  }

  Future<void> deleteContact(String id) async{
    /*List<Widget> memoList = [];
    memoList.add(Container(color: Colors.purple, height: 100,));
    memoList.add(Container(color: Colors.red, height: 100,));
    return memoList;*/
    DBHelper sd = DBHelper();
    return await sd.deleteContact(id);
  }

  Widget contactBuilder(BuildContext parentContext) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container(
            alignment: Alignment.center,
            child: Text('메모를 지금 바로 추가해보세요!'),
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: projectSnap.data?.length,
          itemBuilder: (context, index) {
            Contact? contact = projectSnap.data?[index];
            return InkWell(
              onTap: (){
                Navigator.push(parentContext, CupertinoPageRoute(builder: (context) => ViewInfo(id: contact!.id)));
              },
              onLongPress: (){
                deleteId = contact!.id;
                showAlertDialog(parentContext);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient:LinearGradient(
                      colors: [
                        Colors.orange,
                        Colors.orangeAccent,
                        Colors.red,
                        Colors.redAccent
                        //add more colors for gradient
                      ],
                      begin: Alignment.topLeft, //begin of the gradient color
                      end: Alignment.bottomRight, //end of the gradient color
                      stops: [0, 0.2, 0.5, 0.8], //stops for individual color
                    //set the stops number equal to numbers of color
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contact!.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    Text(contact.phone),
                  ],
                ),
              ),
            );
          },
        );
      },
      future: loadContact(),
    );
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
                setState(() {
                  deleteContact(deleteId);
                  deleteId = '';
                });
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                deleteId = '';
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

}