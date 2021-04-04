import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/CutomerPannel/Cart/MyCartScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NewLatestDetails extends StatefulWidget {
  var storeId;
  String token;
  Products productDetails;

  NewLatestDetails(this.productDetails);

  @override
  _NewLatestDetailsState createState() => _NewLatestDetailsState();
}

class _NewLatestDetailsState extends State<NewLatestDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color1,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Center(
                child: Container(
                  height: 650,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: color6,
                   borderRadius: BorderRadius.circular(40)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 0,),
                      Container(
                        height: 200,
                        width: 430,
                        decoration: BoxDecoration(
                          color: color3,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40),),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.productDetails.image ?? "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg")
                          ),
                        ),
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_back, color: color3,size:30),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2,),
                      Container(
                        height: 150,
                        width: 430,
                        decoration: BoxDecoration(
                          color: color6,
                          //borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40),),
                        ),
                        child: ListView.builder(scrollDirection: Axis.horizontal, itemCount:widget.productDetails.productPictures!=null?widget.productDetails.productPictures.length:0,itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: color3,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(widget.productDetails.image ?? "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg")
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Text(widget.productDetails.name,
                        style: TextStyle(
                            color: color3,
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                     SizedBox(height: 5,),
                     Container(
                       decoration: BoxDecoration(
                         //color: color3,
                         borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40),),
                       ),
                       height: 250,
                       width: 360,
                       child: SingleChildScrollView(
                         child: Column(
                           children: [
                            Card(
                               elevation: 6,
                               color: color6,
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: color6,
                                   borderRadius: BorderRadius.circular(8),
                                   //border: Border.all(color: color3)
                                 ),
                                 child: ListTile(
                                   leading: FaIcon(FontAwesomeIcons.palette, color: color3,),
                                   title: Text("Color: ",
                                     style: TextStyle(
                                         color: color1,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   trailing: Text("Black",
                                     style: TextStyle(
                                         color: color3,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             Card(
                               elevation: 6,
                               color: color6,
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: color6,
                                   borderRadius: BorderRadius.circular(8),
                                   //border: Border.all(color: color3)
                                 ),
                                 child: ListTile(
                                   leading: FaIcon(FontAwesomeIcons.tags, color: color3,),
                                   title: Text("Brand: ",
                                     style: TextStyle(
                                         color: color1,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   trailing: Text("",
                                     style: TextStyle(
                                         color: color3,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             Card(
                               elevation: 6,
                               color: color6,
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: color6,
                                   borderRadius: BorderRadius.circular(8),
                                   //border: Border.all(color: color3)
                                 ),
                                 child: ListTile(
                                   leading: FaIcon(FontAwesomeIcons.boxOpen, color: color3,),
                                   title: Text("Pieces: ",
                                     style: TextStyle(
                                         color: color1,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   trailing: Text("",
                                     style: TextStyle(
                                         color: color3,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   // subtitle: Text("6 Cups, 6 Saucers, 2 Medium Plates, 1 Large Plate",
                                   // style: TextStyle(
                                   //     color: color3,
                                   //     fontSize: 15,
                                   //     fontWeight: FontWeight.bold
                                   // ),
                                   // ),
                                 ),
                               ),
                             ),
                             Card(
                               elevation: 6,
                               color: color6,
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: color6,
                                   borderRadius: BorderRadius.circular(8),
                                   //border: Border.all(color: color3)
                                 ),
                                 child: ListTile(
                                   title: Text("Items: ",
                                     style: TextStyle(
                                         color: color1,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   leading: FaIcon(FontAwesomeIcons.glassCheers, color: color3,),
                                   subtitle: Text(widget.productDetails.description!=null? widget.productDetails.description:"",
                                     style: TextStyle(
                                         color: color3,
                                         fontSize: 15,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             ),

                             Card(
                               elevation: 6,
                               color: color6,
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: color6,
                                   borderRadius: BorderRadius.circular(8),
                                   //border: Border.all(color: color3)
                                 ),
                                 child: ListTile(
                                   leading: FaIcon(FontAwesomeIcons.users, color: color3,),
                                   title: Text("Servings: ",
                                     style: TextStyle(
                                         color: color1,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                   trailing: Text("",
                                     style: TextStyle(
                                         color: color3,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 ),
                               ),
                             ),



                           ],
                         ),
                       )
                     ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                //color: color1,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("", style: TextStyle(
                            color: color6,
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                        ),
                        ),
                        Text("In-Stock", style: TextStyle(
                          color: color3,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        ),

                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("", style: TextStyle(
                            color: color6,
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                        ),
                        ),
                        Text("Sold", style: TextStyle(
                            color: color3,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                        ),
                      ],
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("", style: TextStyle(
                    //         color: color6,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 17
                    //     ),
                    //     ),
                    //     Text("Price", style: TextStyle(
                    //         color: color3,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20
                    //     ),
                    //     ),
                    //
                    //   ],
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
