import 'dart:ui';
import 'package:capsianfood/QRGernator.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Tables/AddTables.dart';
import 'package:capsianfood/screens/Tables/UpdateTables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Chairs/ChairsList.dart';



class TablesList extends StatefulWidget {
  var storeId;

  TablesList(this.storeId);

  @override
  _TablesListState createState() => _TablesListState();
}

class _TablesListState extends State<TablesList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List tablesList=[];
  // bool isListVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      }else{
        Utils.showError(context, "Please Check Internet Connection");
      }
    });



    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: PrimaryColor,size:25),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTables(widget.storeId)));
            },
          ),
        ],
        backgroundColor: BackgroundColor ,
        title: Text('Tables',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getTableList(context, token,widget.storeId)
                  .then((value) {
                setState(() {
                  this.tablesList = value;
                });
              });
            }else{
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: tablesList.length>0?tablesList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      //actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: Colors.blue,
                          caption: 'Update',
                          onTap: () async {
                            //print(discountList[index]);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateTables(tablesList[index],widget.storeId)));
                          },
                        ),
                        IconSlideAction(
                          icon: FontAwesomeIcons.qrcode,
                          color: Colors.blueGrey,
                          caption: 'QR Code',
                          onTap: () async {
                            //print(discountList[index]);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> GenerateScreen("Table/"+tablesList[index]['id'].toString())));
                          },
                        ),

                      ],
                      child: Container(
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                          // ],
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChairsList(tablesList[index])));

                          },
                          child: ListTile(
                            onTap: () {
                            },
                            enabled: tablesList[index]['isVisible'],
                            title: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: FaIcon(FontAwesomeIcons.table, color: PrimaryColor, size: 17,),
                                ),
                                Text('Table Name: ',  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                Text(tablesList[index]['name'],  style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ],
                            ),

                          ),
                        ),

                      ),
                    ),
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}
