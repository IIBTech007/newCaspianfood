import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/constants.dart';

class Reservations extends StatefulWidget {
  var storeId;

  Reservations(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<Reservations> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List reservationList = [];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");
          });
        });
      } else {
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
        iconTheme: IconThemeData(color: yellowColor),
        backgroundColor: BackgroundColor,
        title: Text(
          'Reservations',
          style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Utils.check_connectivity().then((result) {
            if (result) {
              networksOperation.getReservationList(context, token, widget.storeId).then((value) {
                setState(() {
                  reservationList.clear();
                  this.reservationList = value;
                  print(value);
                });
              });
            } else {
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Container(
            decoration: BoxDecoration(),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: reservationList.length,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: FontAwesomeIcons.checkDouble,
                          color: Colors.green,
                          caption: 'Verify ',
                          onTap: () async {
                            networksOperation.reservationVerification(context, token, reservationList[index]['id']).then((value) {
                              if(value!=null){
                                Utils.showSuccess(context, "Reservation Verified");
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                              }else{
                                Utils.showError(context, "Please Try Again");
                              }
                            });
                          },
                        ),

                      ],
                      child: Container(
                       // height: 160,
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
                                    child: FaIcon(
                                      FontAwesomeIcons.utensils,
                                      color: PrimaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    'Store: ',
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    reservationList[index]['storeName']
                                        .toString(),
                                    style: TextStyle(
                                        color: PrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: FaIcon(
                                      FontAwesomeIcons.table,
                                      color: PrimaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    "Table: ",
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    reservationList[index]['table']['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: PrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: FaIcon(
                                      FontAwesomeIcons.userTie,
                                      color: PrimaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    "Customer: ",
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(reservationList[index]['customerName'].toString(),
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
                                    "Verification :",
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
                                  Text(getStatusName(reservationList[index]['status']),
                                    style: TextStyle(
                                        color: PrimaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: FaIcon(
                                      FontAwesomeIcons.calendarAlt,
                                      color: PrimaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    "Date: ",
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    reservationList[index]['date']
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(
                                        color: PrimaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 9),
                                        child: FaIcon(
                                          FontAwesomeIcons.clock,
                                          color: PrimaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "Start Time: ",
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        reservationList[index]['startTime']
                                            .toString(),
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
                                          FontAwesomeIcons.clock,
                                          color: PrimaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "End Time: ",
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        reservationList[index]['endTime']
                                            .toString(),
                                        style: TextStyle(
                                            color: PrimaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
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
                }),
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
