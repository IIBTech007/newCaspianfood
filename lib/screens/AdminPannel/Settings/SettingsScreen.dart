import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Discount/Deals/DealsListInDiscount.dart';
import 'package:capsianfood/screens/AdminPannel/Discount/SingleDiscounts/DiscountItemsList.dart';
import 'package:capsianfood/screens/AdminPannel/Home/DailySessions.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Sizes/SizesList.dart';

import 'package:capsianfood/screens/Tables/TablesList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  var storeId,roleId;

  SettingsPage(this.storeId,this.roleId);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  var claims,userDetail;


  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
         var token = value.getString("token");

          claims= Utils.parseJwt(token);
         print(claims);
         networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
           userDetail = value;
           //  print(value);

         });
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor ,
        title: Text('Settings', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: PrimaryColor, size: 25,),
           onPressed: (){
             SharedPreferences.getInstance().then((value) {
               value.remove("token");
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
             } );
           },
            //onPressed: () => _onActionSheetPress(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: BackgroundColor,
                    border: Border.all(color: yellowColor, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    title: Text("Discounts",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColor
                      ),
                    ),
                    trailing: FaIcon(FontAwesomeIcons.tags, color: yellowColor, size: 25,),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DiscountItemsList(widget.storeId)));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: BackgroundColor,
                    border: Border.all(color: yellowColor, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    title: Text("Deals",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColor
                      ),
                    ),
                    trailing: FaIcon(FontAwesomeIcons.bookmark, color: yellowColor, size: 25,),
                    onTap: (){

                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DealsList(widget.storeId)));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: BackgroundColor,
                    border: Border.all(color: yellowColor, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    title: Text("Sizes",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColor
                      ),
                    ),
                    trailing: FaIcon(FontAwesomeIcons.expandArrowsAlt, color: yellowColor, size: 25,),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SizesListPage(widget.storeId)));
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: BackgroundColor,
                    border: Border.all(color: yellowColor, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: ListTile(
                    title: Text("Daily Sessions",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColor
                      ),
                    ),
                    trailing: FaIcon(FontAwesomeIcons.calendarAlt, color:yellowColor, size: 25,),
                    //Icon(Icons.dashboard, color: yellowColor,),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddSessions(widget.storeId)));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
