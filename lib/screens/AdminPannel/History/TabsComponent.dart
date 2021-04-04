import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/Delivered.dart';
import 'package:capsianfood/screens/AdminPannel/Home/ButtonTabBar/Screens/OrdersRecieved.dart';

import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:capsianfood/Dashboard/IncomeExpense.dart';

import 'package:capsianfood/screens/Reservations/ReservationList.dart';
import 'package:capsianfood/screens/Tables/TablesList.dart';
import 'package:capsianfood/screens/AdminPannel/Home/AllFeedBackList.dart';
import 'package:capsianfood/screens/AdminPannel/Home/DailySessions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRecordTabsScreen extends StatefulWidget {
  var storeId,roleId;
OrderRecordTabsScreen(this.storeId,this.roleId);


  @override
  State<StatefulWidget> createState() {
    return new OrderRecordTabsWidgetState();
  }
}

class OrderRecordTabsWidgetState extends State<OrderRecordTabsScreen> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(

        length: 2,
        child: Scaffold(

          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("IIB",  style: TextStyle(
                      color: BackgroundColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),),

                  accountEmail: Text("admin@admin.com",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? yellowColor : PrimaryColor,
                    backgroundImage: AssetImage('assets/image.jpg'),
                    radius: 60,
                  ),
                ),
                ListTile(
                  title: Text("DashBoard",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor
                    ),
                  ),
                  trailing: FaIcon(FontAwesomeIcons.chartBar, color: yellowColor, size: 25,),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MainPage(widget.storeId)));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Reservation",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor
                    ),
                  ),
                  trailing: FaIcon(FontAwesomeIcons.storeAlt, color: yellowColor, size: 25,),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Reservations(widget.storeId)));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Order FeedBack",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor
                    ),
                  ),
                  trailing: FaIcon(FontAwesomeIcons.commentAlt, color: yellowColor, size: 25,),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AllFeedBackList(widget.storeId)));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Sign Out",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor
                    ),
                  ),
                  trailing: FaIcon(FontAwesomeIcons.signOutAlt, color: yellowColor, size: 25,),
                  onTap: (){
                    SharedPreferences.getInstance().then((value) {
                      value.remove("token");
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                    } );
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: yellowColor
            ),
            title: Text("Orders History", style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold, fontSize: 22),),
            centerTitle: true,
            backgroundColor: BackgroundColor,
            elevation: 0,
            bottom: TabBar(
                indicatorPadding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
                unselectedLabelColor: yellowColor,
                indicatorSize: TabBarIndicatorSize.tab,

                indicator: ShapeDecoration(
                    color: yellowColor,
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: yellowColor,
                        )
                    )
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Received Orders",
                        style: TextStyle(
                          fontSize: 13,
                            fontWeight: FontWeight.bold,

                        //color: Color(0xff172a3a)
                      ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Previous Orders",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            OrdersRecieved(widget.storeId),
            // AllOrders(),
            Delivered(widget.storeId),
          ]),
        )
    );
  }
}