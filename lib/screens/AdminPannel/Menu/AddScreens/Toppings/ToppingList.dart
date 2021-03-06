import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Toppings/updateTopping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddAdditional.dart';




class ToppingLists extends StatefulWidget {
  Products productDetails;

  ToppingLists(this.productDetails);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<ToppingLists>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List allUnitList=[];
  List<Additionals> additionals = [];
  bool isListVisible = false;
  List<Sizes> sizes =[];


  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        print(token);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PrimaryColor,size:25),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddAdditionals(widget.productDetails,token)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          title: Text("Topping List", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getAdditionalsByProductId(context,token,widget.productDetails.id).then((value) {
                  setState(() {
                    additionals = value;
                    print(additionals[0].toString() + "jndkjfdk");
                  });
                });
                networksOperation.getSizes(context,widget.productDetails.storeId).then((value){
                  setState(() {
                    sizes = value;
                    for(int i=0;i<sizes.length;i++) {
                    }
                  });
                });
                networksOperation.getStockUnitsDropDown(context,token).then((value) {
                  print(value[2]['name'].toString()+"Abcccccccccccccc");
                  if(value!=null)
                  {
                    setState(() {
                      allUnitList.clear();
                      allUnitList = value;
                    });
                  }
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
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:additionals == null ? 0:additionals.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Container(
                      //height: 70,
                      //padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                        color: BackgroundColor,
                        border: Border.all(color: yellowColor, width: 2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            caption: 'update',
                            onTap: () async {
                              //print(barn_lists[index]);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateToppings(widget.productDetails,additionals[index],token)));
                            },
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(

                            title: Text(additionals[index].name!=null?additionals[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                           // leading: Image.network(additionals[index].image!=null?additionals[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                            trailing: Text(additionals[index].price!=null?"Price: "+additionals[index].price.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Quantity: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    Text(additionals[index].quantity!=null?additionals[index].quantity.toString():"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Unit: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    Text(additionals[index].unit!=null?getUnitName(additionals[index].unit):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Size : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                    Text(additionals[index].sizeId!=null?getsize(additionals[index].sizeId):"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),),
                                  ],
                                ),
                              ],
                            ),
                            onLongPress:(){
                            //  showAlertDialog(context,additionals[index].id);
                            },
                            onTap: () {
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),













//                child: Scrollbar(
//              child:ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:1, itemBuilder: (context,int index){
//              return Column(
//                children: <Widget>[
//                    SizedBox(height: 10,),
//                    Container(height: 80,
//                      padding: EdgeInsets.only(top: 8),
//                      width: MediaQuery.of(context).size.width * 0.98,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10),
//                          color: Colors.grey.shade300
//                      ),
//                      child: ListTile(
//                        title: Text("Pizza",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                        leading: Image.asset('assets/food10.jpeg',fit: BoxFit.fill,height: 50,width: 50,),
//                        subtitle: Text("Onions,Cheese,Tomato Sauce,Fresh Tomato,",maxLines: 2,),
//                        trailing: Icon(Icons.arrow_forward_ios),
//                       onTap: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(),));
//                       },
//                      ),
//                    ),
//                ],
//              );
//    }),
//                )
            ),
//          child: Scrollbar(
//            // ignore: missing_return
//              child:ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:1, itemBuilder: (context,int index){
//                return Column(
//                  children: <Widget>[
//                    SizedBox(height: 10,),
//                    Container(height: 80,
//                      padding: EdgeInsets.only(top: 8),
//                      width: MediaQuery.of(context).size.width * 0.98,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10),
//                          color: Colors.grey.shade300
//                      ),
//                      child: ListTile(
//                        title: Text("Pizza",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//                        leading: Image.asset('assets/food10.jpeg',fit: BoxFit.fill,height: 50,width: 50,),
//                        subtitle: Text("Onions,Cheese,Tomato Sauce,Fresh Tomato,",maxLines: 2,),
//                        trailing: Icon(Icons.arrow_forward_ios),
//                       onTap: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(),));
//                       },
//                      ),
//                    ),
//
//                  ],
//                );
//              })
//          ),

          ),
        )


    );

  }
  showAlertDialog(BuildContext context,int id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget addSubCategory = FlatButton(
      child: Text("GoTo Details"),
      onPressed: () {
        Navigator.pop(context);
        //Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(id)));
      },
    );
    // Widget addProduct = FlatButton(
    //   child: Text("Add Product"),
    //   onPressed: () {
    //   },
    // );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add SubCategory / Product"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Add SubCategory"),
                onPressed: () {
                },
              ),
              FlatButton(
                child: Text("Add Product"),
                onPressed: () {
                },
              )
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        addSubCategory,
        // addProduct
      ],
    );

    // show the dialog
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  String getUnitName(int id){
    String size="";
    if(id!=null&&allUnitList!=null){
      for(int i = 0;i < 5;i++){
        if(allUnitList[i]['id'] == id) {
          size = allUnitList[i]['name'];
        }
      }
    }
    return size;
  }
  String getsize(int id){
    String size;
    if(id!=null&&sizes!=null){
      for(int i=0;i<sizes.length;i++){
        if(sizes[i].id == id) {
            size = sizes[i].name;
        }
      }
      return size;
    }else
      return "";
  }
}


