import 'dart:ui';
import 'package:capsianfood/Dashboard/IncomeExpense.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/screens/Reservations/ReservationList.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AllFeedBackList.dart';
import 'ButtonTabBar/ButtonTab.dart';
import 'DailySessions.dart';


class FoodDelivery extends StatefulWidget {
  var storeId,roleId,restaurantId;

  FoodDelivery(this.storeId,this.roleId);

  @override
  _FoodDeliveryState createState() => _FoodDeliveryState();
}

class _FoodDeliveryState extends State<FoodDelivery> {
var totalIncome=0.00,token,storeId;
//FirebaseMessaging _firebaseMessaging;

List orderList=[];

@override
  void initState() {
  Utils.check_connectivity().then((result){
    if(result){
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");
          this.storeId = value.getString("storeid");
          print(token);
        });
      });
      print(totalIncome.toString());
    }else{
      Utils.showError(context, "Network Error");
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
        backgroundColor: BackgroundColor ,
        title: Text('Orders',
          style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("IIB",  style: TextStyle(
                  color: whiteTextColor,
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
                backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? yellowColor : blackColor,
                backgroundImage: AssetImage('assets/image.jpg'),
                radius: 60,
              ),
            ),
            ListTile(
              title: Text("DashBoard",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: blackColor
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
                    color: blackColor
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
                    color: blackColor
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
                    color: blackColor
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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: new Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 3),
                ),

                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    //color: Colors.amberAccent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.35 ,
                    child: ButtonTab(widget.storeId),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3, bottom: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
