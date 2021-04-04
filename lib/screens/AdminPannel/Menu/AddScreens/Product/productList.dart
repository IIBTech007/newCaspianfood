import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/updateProduct.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Toppings/ToppingList.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/NewDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../QRGernator.dart';
import 'AddMoreImage.dart';
import 'DetailsPage.dart';
import 'SpecificProductSizes.dart';
import 'addProduct.dart';


class productListPage extends StatefulWidget {
  var categoryId,subCategoryId,storeId;

  productListPage(this.storeId,this.categoryId, this.subCategoryId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<productListPage>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Products> productList=[];
  bool isListVisible = false;

  @override
  void initState() {
    print(widget.storeId.toString()+"storeId");

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
 networksOperation.getProduct(context, widget.categoryId, widget.subCategoryId,widget.storeId).then((value){
   setState(() {
     productList = value;

   });
 });

    // TODO: implement initState
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

              icon: Icon(Icons.add, color: PrimaryColor,size:25,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> addProduct( widget.storeId,widget.categoryId, widget.subCategoryId,)));
              },
            ),
          ],
          backgroundColor:  BackgroundColor,
          title: Text("Product List", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getProduct(context, widget.categoryId, widget.subCategoryId,widget.storeId).then((value){
                  setState(() {
                    productList = value;

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
                  image: AssetImage('assets/bb.jpg'),
                )
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new Container(
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productList == null ? 0:productList.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(height: 70,
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        //padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.20,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              icon: Icons.add_a_photo,
                              color: Colors.blue,
                              caption: 'Add Image',
                              onTap: () async {
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>AddMoreImages( widget.storeId,widget.categoryId, widget.subCategoryId, productList[index],)));
                              },
                            ),
                            IconSlideAction(
                              icon: Icons.edit,
                              color: Colors.blue,
                              caption: 'Update',
                              onTap: () async {
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateProduct( widget.storeId,widget.categoryId, widget.subCategoryId, productList[index],)));
                              },
                            ),
                            IconSlideAction(
                              icon: FontAwesomeIcons.qrcode,
                              color: Colors.blueGrey,
                              caption: 'QR Code',
                              onTap: () async {
                                //print(discountList[index]);
                                Navigator.push(context,MaterialPageRoute(builder: (context)=> GenerateScreen("Product/"+productList[index].id.toString())));
                              },
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(

                              title: Text(productList[index].name!=null?productList[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                              leading: Image.network(productList[index].image!=null?productList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                              onLongPress:(){
                              },
                              onTap: () {
                                 _showPopupMenu(productList[index].id,productList[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        )


    );

  }
  // showAlertDialog(BuildContext context,int productId) {
  //   Widget cancelButton = FlatButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
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
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Add Toppings"),
  //               onPressed: () {
  //                 Navigator.push(context,MaterialPageRoute(builder: (context)=>AddToppings()));
  //               },
  //             )
  //           ],
  //         );
  //       },
  //     ),
  //     actions: [
  //       cancelButton,
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
        PopupMenuItem<String>(
            child: const Text('Detail Page'), value: 'detail'),
      ],
      elevation: 8.0,
    ).then((value){
      if(value == "sizes"){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>SpecificSizesPage(productDetails)));
      }else if(value == "topping"){
        print(productDetails.id);
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ToppingLists(productDetails)));
      }
      else if(value == "detail"){
        print(productDetails.id);
        Navigator.push(context,MaterialPageRoute(builder: (context)=> NewLatestDetails(productDetails)));
      }
    });
  }
}


