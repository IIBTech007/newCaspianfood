import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/screens/AdminPannel/Home/OrderDetail.dart';
import 'package:capsianfood/screens/GetCustomerLocation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/networks/network_operations.dart';


class ActiveOrders extends StatefulWidget {
  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<ActiveOrders> {
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<Categories> categoryList=[];
  List orderList = [];
  bool isListVisible = false;
  List<Store> allStoreList=[];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });



    // TODO: implement initState
    super.initState();
  }

  String getStoreName(int id){
    String storeName;
    if(id != null && allStoreList!=null){
      for(int i=0;i<allStoreList.length;i++){
        if(allStoreList[i].id == id){
          storeName = allStoreList[i].name;
          return storeName;
        }
      }
    }else
      return "abc";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              var storeData={
                "IsProduct":false
              };
              networksOperation.getAllStore(context, storeData).then((value) {
                setState(() {
                  allStoreList = value;
                });
              });
              networksOperation.getOrdersByCustomer(context, token).then((value) {
                setState(() {

                  orderList.clear();
                  if(value!=null) {
                    for (int i = 0; i < value.length; i++) {
                      if (value[i]['orderStatus'] != 7 && value[i]['orderStatus'] != 2) {
                         orderList.add(value[i]);
                      }
                    }
                  }
                  else
                    orderList =null;

                  // print(value.toString());
                });
              });
            }else{
              Utils.showError(context, "Please Check Your Internet");
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
                itemCount: orderList!=null?orderList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: BackgroundColor,
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                        child: InkWell(
                          onTap: () {

                          },
                          child: ExpansionTile(
                            //backgroundColor: Colors.white12,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      Text('Order Status:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getStatus(orderList!=null?orderList[index]['orderStatus']:null),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      Text('Order Type:',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.5),
                                      ),
                                      Text(getOrderType(orderList[index]['orderType']),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(orderList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [ Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 0),
                                child: Text(orderList[index]['storeId']!=null?getStoreName(orderList[index]['storeId']).toString():"",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: PrimaryColor
                                  ),
                                ),
                              ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 0),
                                  child: Text(orderList[index]['id']!=null?'ORDER ID: '+orderList[index]['id'].toString():"",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: yellowColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, bottom: 15 , left: 5,  right: 5),
                                child: Container(
                                 // color: Colors.black,
                                  width: MediaQuery.of(context).size.width,
                                  // height: MediaQuery.of(context).size.height / 1.129,
                                  child:Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap:(){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailPage(Order: orderList[index],)));


                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5, right: 10),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                            color: yellowColor,
                                                            //border: Border.all(color: Colors.amberAccent)
                                                        ),
                                                        width: 100,
                                                        height:40,

                                                        child: Center(
                                                          child: Text("View Details",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: orderList[index]['orderStatus'] == 6,
                                                    child: InkWell(
                                                      onTap:(){
                                                        print(orderList[index].toString());
                                                        networksOperation.getDriverLocation(context, token, orderList[index]['id'],orderList[index]['driverId']).then((value){
                                                          print(value);
                                                          if(value['driverLongitude']!=null && orderList[index]['driverLatitude']!=null){
                                                            print(orderList[index]['driverLatitude'].toString());
                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCutomerLocation(longitude: value!=null?double.parse(value['driverLongitude']):double.parse(orderList[index]['driverLongitude']),
                                                            latitude: value!=null?double.parse(value['driverLatitude']):double.parse(orderList[index]['driverLatitude']),)));
                                                       }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                              color: yellowColor,
                                                              //border: Border.all(color: Colors.amberAccent)
                                                          ),
                                                          width: 120,
                                                          height:40,

                                                          child: Center(
                                                            child: Text("Driver Location",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Visibility(
                                                    visible: orderList[index]['orderStatus'] == 1,
                                                    child: InkWell(
                                                      onTap:(){
                                                        networksOperation.removeOrder(context, token, orderList[index]['id'], 2).then((value){
                                                          if(value){
                                                            WidgetsBinding.instance
                                                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                                                          }else{
                                                            Utils.showError(context, "Please Try Again");
                                                          }
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                                              color: yellowColor,
                                                              //border: Border.all(color: Colors.amberAccent)
                                                          ),
                                                          width: 120,
                                                          height:40,

                                                          child: Center(
                                                            child: Text("Cancel Order",style: TextStyle(color: BackgroundColor,fontSize: 15,fontWeight: FontWeight.bold),),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }

  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "None";
      }
      else if(id ==1){
        status = "InQueue";
      }else if(id ==2){
        status = "Cancel";
      }else if(id ==3){
        status = "OrderVerified";
      }else if(id ==4){
        status = "InProgress";
      }else if(id ==5){
        status = "Ready";
      } else if(id ==6){
        status = "On The Way";
      }else if(id ==7){
        status = "Delivered";
      }

      return status;
    }else{
      return "";
    }
  }


}
