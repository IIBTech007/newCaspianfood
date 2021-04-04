import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/Reservations/AddReservation.dart';
import 'package:capsianfood/screens/Reservations/UpdateReservations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/constants.dart';




class CustomerReservations extends StatefulWidget {


  @override
  _CustomerReservationsState createState() => _CustomerReservationsState();
}

class _CustomerReservationsState extends State<CustomerReservations> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token,userId;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List reservationList=[];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if(value){
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
            this.userId = value.getString("userId");
            print(userId+"jhghjhgfghjh");
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
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: PrimaryColor,size:25),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddReservations()));
            },
          ),
        ],
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Reservations',
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
              networksOperation.getReservationByCustomerId(context, token,int.parse(userId)).then((value) {
                setState(() {
                  reservationList.clear();
                  this.reservationList = value;
                 // print(reservationList[5]);
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
                itemCount: reservationList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: Colors.blue,
                          caption: 'Update',
                          onTap: () async {
                            if(DateTime.parse(reservationList[index]['date'].toString()).isAfter(DateTime.now())){
                               Navigator.push(context,MaterialPageRoute(builder: (context)=> UpdateReservations(reservationList[index])));
                            }else{
                              Utils.showError(context, "You Can't reservation Today");
                            }
                          }
                        ),
                        IconSlideAction(
                          icon: FontAwesomeIcons.checkDouble,
                          color: Colors.green,
                          caption: 'Attend',
                          onTap: () async {
                            print(reservationList[index]);

                            DateTime now = DateTime.now().subtract(Duration(hours: 28));
                            DateTime date = DateTime.parse(reservationList[index]['date'].toString());
                            String myDate = DateFormat('yyyy-MM-dd').format(date);
                            String nowDate = DateFormat('yyyy-MM-dd').format(now);
                            print(myDate+"   "+nowDate);
                            print(int.parse(reservationList[index]['startTime'].toString().substring(0,2)) >= TimeOfDay.now().hour);
                            if(myDate == nowDate){

                              if((int.parse(reservationList[index]['startTime'].toString().substring(0,2)) >= TimeOfDay.now().hour ||
                                  int.parse(reservationList[index]['endTime'].toString().substring(0,2)) <= TimeOfDay.now().hour-7) &&
                                  int.parse(reservationList[index]['startTime'].toString().substring(3,5)) >= TimeOfDay.now().minute){

                                networksOperation.changeReservationStatus(context, token, reservationList[index]['id'], 2).then((value) {
                                  Utils.showSuccess(context, "Submitted");
                                  print(value);
                                });

                              }
                            }
                            //print(discountList[index]);
                          },
                        ),
                        IconSlideAction(
                          icon: Icons.not_interested,
                          color: Colors.red,
                          caption: 'Cancel',
                          onTap: () async {
                            print(DateTime.parse(reservationList[index]['date'].toString()).isAfter(DateTime.now()));
                            if(DateTime.parse(reservationList[index]['date'].toString()).isAfter(DateTime.now())){
                               networksOperation.changeReservationStatus(context, token, reservationList[index]['id'], 3);
                              }
                          },
                        ),

                      ],
                      child: Container(
                       // height: 130,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 20,),
                                  ),
                                  Text('Store: ', style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  ),
                                 Text(reservationList[index]['storeName'].toString(),  style: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: FaIcon(FontAwesomeIcons.table, color: PrimaryColor, size: 20,),
                                ),
                                Text("Table: ", style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold),),
                                Text(reservationList[index]['table']['name'],maxLines: 1,overflow: TextOverflow.clip, style: TextStyle(
                                  color: PrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                ),
                              ],),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 9),
                                        child: FaIcon(
                                          FontAwesomeIcons.sign,
                                          color: PrimaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "Status :",
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(reservationList[index]['isVerified']==true?"Verified":"Non Vefify",
                                        style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 9),
                                        child: FaIcon(
                                          Icons.donut_large,
                                          color: PrimaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "Attend :",
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(getStatusName(reservationList[index]['status']),
                                        style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: FaIcon(FontAwesomeIcons.calendarAlt, color: PrimaryColor, size: 20,),

                                  ),
                                  Text("Date: ", style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold),),
                                  Text(reservationList[index]['date'].toString().substring(0,10),  style: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 9),
                                        child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 20,),

                                      ),
                                      Text("Start Time: ", style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold),),
                                      Text(reservationList[index]['startTime'].toString(),  style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 9),
                                        child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 20,),

                                      ),
                                      Text("End Time: ", style: TextStyle(color: yellowColor, fontSize: 17, fontWeight: FontWeight.bold),),
                                      Text(reservationList[index]['endTime'].toString(),  style: TextStyle(
                                          color: PrimaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
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
  String getStatusName(int id){
    String name;
    if(id!=null){
      if(id==0){
        name = "None";
      }else if(id == 1){
        name= "Attended";
      }else if(id == 2){
        name= "Not Attended";
      }
      return name;
    }else{
      return "";
    }
  }



}
