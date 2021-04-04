import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/WelcomeScreens/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  var storeId,roleId;

  AdminProfile(this.storeId,this.roleId);

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var totalIncome=0.0,token,claims,userDetail;
  List orderList=[];



@override
  void initState() {
  Utils.check_connectivity().then((result){
    if(result){
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");
          claims= Utils.parseJwt(token);
          networksOperation.getCustomerById(context, token, int.parse(claims['nameid'])).then((value){
            setState(() {
              userDetail = value;
            });
          });
          networksOperation.getAllOrdersByCustomer(context, token,widget.storeId).then((value) {
            // orderList.clear();
            if(value!=null) {
              for (int i = 0; i < value.length; i++) {
                if (value[i]['orderStatus'] == 7)
                  orderList.add(value[i]['grossTotal']);
              }
              for(int i = 0; i < orderList.length; i++){
                setState(() {
                  totalIncome += double.parse(orderList[i].toString());
                });

              }
            }
            else
              orderList =null;

            // print(value.toString());
          });
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
      appBar:   AppBar(
        actions: [
          IconButton(
            icon:  FaIcon(FontAwesomeIcons.signOutAlt, color: PrimaryColor, size: 25,),
            onPressed: (){
              SharedPreferences.getInstance().then((value) {
                value.remove("token");
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              } );
            },
          ),
        ],
        title: Center(
          child: Text('Admin Profile',
            style: TextStyle(
                color: yellowColor,
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),
          )
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor,
        automaticallyImplyLeading: false,
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
            //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0)),
                    color: Colors.white12,
                    border: Border.all(color: yellowColor,width: 2)
                  ),
                  height:280,
                  width: MediaQuery.of(context).size.width-10,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 15, bottom: 20),
                        child: Center(
                          child: Container(
                            child:  CircleAvatar(
                              radius: 75,
                              backgroundColor: yellowColor,
                              child: CircleAvatar(
                                backgroundImage:
                                //AssetImage('assets/image.jpg'),
                                NetworkImage(userDetail!=null?userDetail['image']!=null?userDetail['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg'
                                    :"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg"),
                                radius: 70,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(claims!=null?claims['unique_name']:"",
                          style: TextStyle(
                          color: yellowColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                        ),
                      ),
                      Center(
                        child: Text(claims!=null?claims['role']:"",
                          style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        //         Padding(
        //           padding: EdgeInsets.only(top: 8),
        //         ),
        //          Container(
        //             width: MediaQuery.of(context).size.width,
        //             height: 150,
        //            child: Column(
        //              children: [
        //                Padding(
        //                  padding: const EdgeInsets.all(5.0),
        //                  child: Container(
        //                    width: MediaQuery.of(context).size.width,
        //                    height: 50,
        //                    decoration: BoxDecoration(
        //                        borderRadius: BorderRadius.circular(9),
        //                        color: Colors.white12,
        //                        border: Border.all(color: yellowColor,width: 2)
        //                    ),
        //                    child: Padding(
        //                      padding: const EdgeInsets.all(8.0),
        //                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                        children: [
        //                          Text("Total Earnings", style: TextStyle(fontSize: 20, color: yellowColor, fontWeight: FontWeight.bold),),
        //                          Text(totalIncome.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
        //                        ],
        //                      ),
        //                    ),
        //                  ),
        //                ),
        //                Padding(
        //                  padding: const EdgeInsets.all(5.0),
        //                  child: Container(
        //                    width: MediaQuery.of(context).size.width,
        //                    height: 50,
        //                    decoration: BoxDecoration(
        //                        borderRadius: BorderRadius.circular(9),
        //                        color: Colors.white12,
        //                        border: Border.all(color: yellowColor,width: 2)
        //                    ),
        //                    child: Padding(
        //                      padding: const EdgeInsets.all(8.0),
        //                      child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                        children: [
        //                          Text("Total Orders", style: TextStyle(fontSize: 20, color: yellowColor, fontWeight: FontWeight.bold),),
        //                          Text(orderList!=null?orderList.length.toString():"", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PrimaryColor),),
        //                        ],
        //                      ),
        //                    ),
        //                  ),
        //                )
        //              ],
        //            )
        // ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height:300 ,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: BackgroundColor,
                        border: Border.all(color: yellowColor,width: 2)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FaIcon(FontAwesomeIcons.userTie, color: yellowColor, size: 30,),
                              ),
                              //Padding(padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('About',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColor)),
                              ),
//                                Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child:InkWell
//                                    (
//                                      onTap: (){
//
//                                      },
//                                      child: FaIcon(FontAwesomeIcons.solidEdit, color: Colors.amberAccent, size: 25,)),
//                                ),
//                              InkWell(
//                                onTap:(){
//                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> EditOrder()));
//
//
//                                },
//                                child: Padding(
//                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 85),
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.all(Radius.circular(10)) ,
//                                        color: Color(0xFF172a3a),
//                                        border: Border.all(color: Colors.amberAccent)
//                                    ),
//                                    width: MediaQuery.of(context).size.width / 6,
//                                    height: MediaQuery.of(context).size.height  * 0.04,
//
//                                    child: Center(
//                                      child: Text("Edit",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
//                                    ),
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: yellowColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Admin Name:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(claims!=null?claims['unique_name']:"",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: PrimaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Email:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(userDetail!=null?userDetail['email']:"",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: PrimaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Contact:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(userDetail!=null?userDetail['cellNo'].toString():"",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: PrimaryColor
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Address:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: yellowColor
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(userDetail!=null?userDetail['address']+","+userDetail['city']+","+userDetail['country']:"",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: PrimaryColor
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 45),
                        //   child: Text(userDetail!=null?userDetail['address']+","+userDetail['city']+","+userDetail['country']:"",
                        //     maxLines: 2,
                        //     style: TextStyle(
                        //         fontSize: 17,
                        //         fontWeight: FontWeight.bold,
                        //         color: PrimaryColor
                        //     ),
                        //   ),
                        // ),
//                          Padding(
//                            padding: const EdgeInsets.all(7.0),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: [
//                                Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Row(
//                                      children: [
//                                        Text('Change Password',
//                                          style: TextStyle(
//                                              fontSize: 17,
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.amberAccent
//                                          ),
//                                        ),
//                                      ],
//                                    )
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child:InkWell
//                                    (
//                                    onTap: (){
//
//                                    },
//                                      child: FaIcon(FontAwesomeIcons.key, color: Colors.amberAccent, size: 25,)),
//                                ),
//
//                              ],
//                            ),
//                          ),
                      ],
                    ),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
