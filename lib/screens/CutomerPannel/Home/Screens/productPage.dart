import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Additional_details.dart';
import '../../Cart/MyCartScreen.dart';
import 'FoodDetail.dart';
import 'NewDetails.dart';


class ProductPage extends StatefulWidget {
  var categoryId,subCategoryId;
  String categoryName;
  var storeId;

  ProductPage(this.categoryId,this.subCategoryId,this.categoryName,this.storeId);

  @override
  _ProductPageState createState() => _ProductPageState(this.categoryId,this.subCategoryId,this.categoryName);
}

class _ProductPageState extends State<ProductPage>{
  var categoryId,subCategoryId,totalItems;
  String categoryName;
  List<Products> productlist=[];
  var token;

  _ProductPageState(this.categoryId,this.subCategoryId, this.categoryName);


  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
          setState(() {
            this.token = value.getString("token");

          });
        });
        networksOperation.getProduct(context, categoryId, subCategoryId,widget.storeId).then((
            value) {
          setState(() {
            productlist = value;
            print(value);
          });
        });
      }
    });
    sqlite_helper().getcount().then((value) {
      //print("Count"+value.toString());
      totalItems = value;
      //print(totalItems.toString());
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BackgroundColor ,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20,top: 15),
              child: Badge(
                showBadge: true,
                borderRadius: 10,
                badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
                // padding: EdgeInsets.all(7),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(ishome: false,),));

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_cart, color: PrimaryColor, size: 25,),
                  ),
                ),
              ),
            ),
          ],
          titleSpacing: 50,
          title: Row(
            children: [
              FaIcon(FontAwesomeIcons.codeBranch, color: PrimaryColor, size: 25,),
              SizedBox(width: 5,),
              Text(categoryName!=null?categoryName:"Food Items",
                style: TextStyle(
                    color: yellowColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        body: Container(
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
              child: ListView.builder(padding: EdgeInsets.all(4), scrollDirection: Axis.vertical, itemCount:productlist == null ? 0:productlist.length, itemBuilder: (context,int index){
                return Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Container(height: 80,
                      padding: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.98,
                      decoration: BoxDecoration(
                          color: BackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          border: Border.all(color: yellowColor, width: 2)
                      ),
                      child: ListTile(
                        title: Text(productlist[index].name!=null?productlist[index].name:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                        leading: Image.network(productlist[index].image!=null?productlist[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                        subtitle: Text(productlist[index].description!=null?productlist[index].description:"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),
                        trailing: InkWell(
                          child: Icon(Icons.add_shopping_cart,size: 30,color: yellowColor,),
                          onTap: () {
                            print(productlist[index]);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productlist[index].id,productlist[index],null),));
                          },),
                        onTap: () {
                          print(productlist[index].description);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => StoreHomePage(token,stor),));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NewLatestDetails(productlist[index]),));
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Detail_page(categoryId,productlist[index].id,productlist[index],productlist[index].name,productlist[index].description,productlist[index].image),));
                        },
                      ),
                    ),
                  ],
                );
              })
          ),

        )


    );

  }
}

