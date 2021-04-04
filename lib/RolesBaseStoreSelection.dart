import 'dart:convert';
import 'dart:ui';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/AdminNavBar/AdminNavBar.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';






class RoleBaseStoreSelection extends StatefulWidget {
  List roles=[];

  RoleBaseStoreSelection(
      this.roles); //StoreList(this.restaurantId); // StoreList({this.categoryId, this.subCategoryId});

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<RoleBaseStoreSelection>{
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Store> storeList=[];
  List rolesList=[],restaurantList=[];
 bool isVisible =false;
  @override
  void initState() {
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());

      restaurantList.clear();
      for(int i=0;i<widget.roles.length;i++){
      if(widget.roles[i]['restaurant']!=null){
        restaurantList.add(widget.roles[i]['restaurant']);
      }
      // if(widget.roles[i]['roleId'] == 2){
      //   isVisible =true;
      // }
    }

    networksOperation.getRoles(context).then((value) {
      setState(() {
        rolesList = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  String getRoleName (int id){
    String roleName;
    if(id!=null && rolesList!=null){
      for(int i=0;i<rolesList.length;i++){
        if(rolesList[i]['id'] == id){
            roleName = rolesList[i]['name'];
        }
      }
      return roleName;
    }else{
      return "";
    }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor:  BackgroundColor,
          title: Text("Select Branch", style: TextStyle(
              color: yellowColor,
              fontSize: 25,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildWideContainers();
            } else {
              return _buildNormalContainers();
            }
          },
        ),
    );
  }
  // showAlertDialog(BuildContext context,int productId) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Add Size/Topping"),
  //     content: StatefulBuilder(
  //       builder: (context, setState) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             FlatButton(
  //               child: Text("Add Sizes"),
  //               onPressed: () {
  //                // Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Sizes()));
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Add Toppings"),
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(builder: (context)=>AddToppings(productId)));
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //     actions: [
  //       cancelButton,
  //       // SizeList,
  //       //  ToppingList
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
  void _showPopupMenu(int productId,Products productDetails ) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
            child: const Text('Sizes List'), value: 'sizes'),
        PopupMenuItem<String>(
            child: const Text('Topping List'), value: 'topping'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "sizes"){
        //Navigator.push(context,MaterialPageRoute(builder: (context)=>SpecificSizesPage(productDetails)));
      }else if(value == "topping"){
        //Navigator.push(context,MaterialPageRoute(builder: (context)=> ToppingLists(productId)));
      }
    });
  }

  Widget _buildNormalContainers() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage('assets/bb.jpg'),
          ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: new Container(
        //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
        child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:widget.roles == null ? 0:widget.roles.length, itemBuilder: (context,int index){
          return InkWell(
            onTap: () {
              if(widget.roles[index]['roleId'] == 3||widget.roles[index]['roleId'] == 4) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => AdminNavBar(widget.roles[index]['storeId'],widget.roles[index]['roleId'])), (
                        Route<dynamic> route) => false);
              }
              else if(widget.roles[index]['roleId'] == 9){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => ClientNavBar()), (
                        Route<dynamic> route) => false);
              }
            },
            child: Card(
              elevation: 7,
              //color: Colors.white24,
              child: Container(
                //height: 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: yellowColor, width: 2),
                  borderRadius: BorderRadius.circular(9)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 5, right: 1, bottom: 5),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(widget.roles[index]['image']!=null?widget.roles[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',),
                                ),
                                //color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 3, right: 2, bottom: 5),
                          child: Container(
                            width: 1,
                            height: 120,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 3, right: 2, bottom: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width/1.7,
                          //  height: 120,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 17,),
                                    ),
                                    Container(width: MediaQuery.of(context).size.width/2,child: Text(" ${widget.roles[index]['restaurant']!=null?"Restaurant: "+widget.roles[index]['restaurant']['name']:" - "}",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: yellowColor),)),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 1),
                                      child: FaIcon(FontAwesomeIcons.storeAlt, color: PrimaryColor, size: 13,),
                                    ),
                                    Text(widget.roles[index]['store']!=null?"Branch: "+widget.roles[index]['store']['name']:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: yellowColor),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 1),
                                      child: FaIcon(FontAwesomeIcons.city, color: PrimaryColor, size: 13,),
                                    ),
                                    Text("City: ${widget.roles[index]['store']['city']!=null?widget.roles[index]['store']['city']:""}",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: FaIcon(FontAwesomeIcons.userTie, color: PrimaryColor, size: 13,),
                                    ),
                                    Text("Role: ${getRoleName(widget.roles[index]['roleId'])}",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                                SizedBox(height: 3.5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 3),
                                          child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 16,),
                                        ),
                                        Text("Open: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                                        Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['openTime']:""}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
                                      ],
                                    ),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor, size: 16,),
                                    ),
                                    Text("Close: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                                    Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['closeTime']:""}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
  Widget _buildWideContainers() {
    return Container(
        decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )
          ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: widget.roles == null ? 0:widget.roles.length,
            itemBuilder: (context,int index){
              return Card(
                color: BackgroundColor,
                elevation: 7,
                child: InkWell(
                  onTap: () {
                    if(widget.roles[index]['roleId'] == 3||widget.roles[index]['roleId'] == 4) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => AdminNavBar(widget.roles[index]['storeId'],widget.roles[index]['roleId'])), (
                              Route<dynamic> route) => false);
                    }
                    else if(widget.roles[index]['roleId'] == 9){
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => ClientNavBar()), (
                              Route<dynamic> route) => false);
                    }
                  },
                  child: Container(
                    //alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: yellowColor, width: 2),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(

                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.roles[index]['image']!=null?widget.roles[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',),
                              ),
                              //color: Colors.lightGreen,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft:  Radius.circular(15) )),
                          width: MediaQuery.of(context).size.width,
                          height: 225,
                          //child: Image.network(widget.roles[index]['image']!=null?widget.roles[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill),
                        ),
                        Padding(padding: EdgeInsets.all(2),),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 5),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 11),
                                child: FaIcon(FontAwesomeIcons.utensils, color: PrimaryColor, size: 15,),
                              ),
                              Text("Restaurant: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              Text("${widget.roles[index]['restaurant']!=null?widget.roles[index]['restaurant']['name']:" - "}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 2),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: FaIcon(FontAwesomeIcons.storeAlt, color: PrimaryColor, size: 15,),
                              ),
                              Text("Store: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              Text(widget.roles[index]['store']!=null?widget.roles[index]['store']['name']:" - ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryColor),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 7),
                                    child: FaIcon(FontAwesomeIcons.city, color: PrimaryColor, size: 15,),
                                  ),
                                  Text("City: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                  Text("${widget.roles[index]['store']['city']}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold, fontSize: 17),),
                                ],
                              ),
                              Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: FaIcon(FontAwesomeIcons.userTie, color: PrimaryColor, size: 20,),
                                    ),
                                    Text("Role: ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                    Text("${getRoleName(widget.roles[index]['roleId'])}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold, fontSize: 17),),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor),
                                  ),
                                  Text("Open: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                                  Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['openTime']:""}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FaIcon(FontAwesomeIcons.clock, color: PrimaryColor),
                                  ),
                                  Text("Close: ",style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),),
                                  Text("${widget.roles[index]['store']!=null?widget.roles[index]['store']['closeTime']:""}",style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

