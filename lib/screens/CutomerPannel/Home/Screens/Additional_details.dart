import 'dart:convert';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:capsianfood/LibraryClasses/flutter_counter.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/CartItems.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/model/Toppings.dart';
import 'package:capsianfood/screens/CutomerPannel/Cart/MyCartScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'AddToppingwithList.dart';
import '../../ClientNavBar/ClientNavBar.dart';

class AdditionalDetail extends StatefulWidget {
  var categoryId=0,productId,id;
  Products productDetails;


  AdditionalDetail(this.productId,this.productDetails,this.id);

  @override
  _AdditionalDetailState createState() => _AdditionalDetailState(this.productId,this.id);
}

class _AdditionalDetailState extends State<AdditionalDetail> {
  var categoryId,productId,id;


  _AdditionalDetailState(this.productId,this.id);
  List<Widget> chips=[];
  List<dynamic> prices=[];
  num _defaultValue = 1;
  num _counter = 1;
  final _formKey = GlobalKey<FormState>();
  String selectedSize,intialSelectedSize,selectedBase,price;
  int selectedSizeId,selectedSauceId,selectedBaseId;
  var totalItems;
  var totalToppingPrice=0.0;
  var totalprice=0.0;
  bool isExisting=true;
  var cart;
  List<dynamic> productSizesDetails=[];
  List<Toppings> additionals =[];
  List sizesList= [], baseList=[];





  @override
  void initState() {
    setState(() {
      for (int i = 0; i < widget.productDetails.productSizes.length; i++) {
        sizesList.add(widget.productDetails.productSizes[i]['size']['name']);
        productSizesDetails.add(widget.productDetails.productSizes[i]);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor ,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text(widget.productDetails.name,
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 15),
            child: Badge(
              showBadge: true,
              borderRadius: 10,
              badgeContent: Center(child: Text(totalItems!=null?totalItems.toString():"0",style: TextStyle(color: BackgroundColor,fontWeight: FontWeight.bold),)),
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
                SizedBox(height: 5,),
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        color: BackgroundColor,
                        borderRadius: BorderRadius.circular(9),
                        //border: Border.all(color: yellowColor, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width*0.98,
                    padding: EdgeInsets.all(14),

                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Form(
                        key: _formKey,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Size",

                            // alignLabelWithHint: false,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color:
                              yellowColor),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color:
                              yellowColor),
                            ),
                          ),

                          // isExpanded: true,
                          // isDense: false,

                          validator: (value) => value == null
                              ? 'Please fill in your size' : null,
                          value: selectedSize,

                          //  autovalidate: true,
                          onChanged: (Value) {
                            setState(() {
                              selectedSize = Value;
                              selectedSizeId = sizesList.indexOf(selectedSize);
                              totalprice= _counter*((totalToppingPrice) +
                                  (widget.productDetails.productSizes[selectedSizeId]['discountedPrice']!=0.0?
                              widget.productDetails.productSizes[selectedSizeId]['discountedPrice']:
                              widget.productDetails.productSizes[selectedSizeId]['price'])
                              );
                              print("size price"+widget.productDetails.productSizes[selectedSizeId]['price'].toString());
                              print("Total price"+totalprice.toString());
                              print("Counter  "+_counter.toString());
                              print("Topping price  "+totalToppingPrice.toString());
                            });
                            chips.clear();
                            prices.clear();
                            totalToppingPrice=0.0;
                            sqlite_helper().checkAlreadyExists(productId).then((cartitem) {
                              setState(() {
                                if(cartitem!=null){
                                  cart = cartitem ;
                                }
                                if(cart!=null&&cartitem.length>0) {
                                  for(int i=0;i<cart.length;i++) {
                                    if (cart[i]['productId'] == productId) {
                                      if(cart[i]['sizeName'] == productSizesDetails[selectedSizeId]['size']['name']) {
                                        print("nkjnbjbjhbhj"+productSizesDetails[selectedSizeId]['size']['name']);
                                        //   return true;
                                        // else
                                        //   return false;
                                        isExisting = true;
                                      }else{
                                        isExisting =false;
                                      }
                                      //  print(isExisting.toString());
                                    }else{
                                     // isExisting =false;
                                    }
                                  }
                                }else{
                                  isExisting =false;
                                }
                              });
                            });
                          },
                          items: sizesList.map((value) {
                            return  DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    value,
                                    style:  TextStyle(color: yellowColor,fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedSizeId!=null,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: BackgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: yellowColor, width: 2)
                      ),
                      child: ListTile(

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(translate('add_to_cart_screen.quantity'),style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor),),
                            ),
                            Counter(
                              initialValue: _defaultValue,
                              minValue: 1,
                              maxValue: 100,
                              step: 1,
                              decimalPlaces: 0,
                              onChanged: (value) {
                                setState(() {
                                  _defaultValue = value;
                                  _counter = value;
                                  totalprice= _counter*((totalToppingPrice) +
                                      (widget.productDetails.productSizes[selectedSizeId]['discountedPrice']!=0.0?
                                      widget.productDetails.productSizes[selectedSizeId]['discountedPrice']:
                                      widget.productDetails.productSizes[selectedSizeId]['price'])
                                  );
                                  print("size price"+widget.productDetails.productSizes[selectedSizeId]['price'].toString());
                                  print("Total price"+totalprice.toString());
                                  print("Counter  "+_counter.toString());
                                  print("Topping price  "+totalToppingPrice.toString());
                                  // totalprice= _counter*(totalToppingPrice + getprice(selectedSize));
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedSizeId!=null,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: BackgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: yellowColor, width: 2)
                      ),
                      child: ListTile(

                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("Product Actual Price",style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(selectedSizeId!=null?widget.productDetails.productSizes[selectedSizeId]['price'].toString():"",style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor, fontSize: 17),),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedSizeId!=null&&widget.productDetails.productSizes[selectedSizeId]['discountId']!=null,
                  child: Container(
                    decoration: BoxDecoration(
                        color: BackgroundColor,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: yellowColor, width: 2)
                    ),
                    child: ListTile(

                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Discount Price",style: TextStyle(fontWeight: FontWeight.bold,color: yellowColor),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(selectedSizeId!=null?widget.productDetails.productSizes[selectedSizeId]['discountedPrice'].toString():"",style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor),),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        //color: BackgroundColor,
                        borderRadius: BorderRadius.circular(9),
                        //border: Border.all(color: yellowColor, width: 2)
                    ),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 2,),
                              Center(child: Text(totalprice.toStringAsFixed(1),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: yellowColor),)),

                            ],
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width*0.6,
                              height: MediaQuery.of(context).size.height  * 0.06,
                              decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(8),

                              ),
                              child: Center(

                                child: Text( translate('buttons.add_to_cart'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: BackgroundColor),),
                              ),
                            ),
                            onTap: () {
                              print(widget.productDetails.storeId);
                              print(widget.productDetails.productSizes[selectedSizeId]['discountId']!=null?
                              widget.productDetails.productSizes[selectedSizeId]['discountedPrice']:
                              widget.productDetails.productSizes[selectedSizeId]['price'].toString()+"iuyiuoiyui");
                              if(_formKey.currentState.validate()) {
                                var encoded;
                                encoded = jsonEncode(additionals);
                                if(isExisting){
                                  Utils.showError(context, "Item Already Exist");
                                  setState(() {
                                  });
                                }
                                else if(!isExisting){
                                  print(selectedBaseId.toString());
                                  print("else if 3");
                                  if(cart.length>0){
                                    if(widget.productDetails.storeId == cart[0]['storeId']){
                                      sqlite_helper().create_cart(CartItems(
                                          productId: productId,
                                          productName: widget.productDetails.name,
                                          price: widget.productDetails.productSizes[selectedSizeId]['discountId']!=null?
                                          widget.productDetails.productSizes[selectedSizeId]['discountedPrice']:
                                          widget.productDetails.productSizes[selectedSizeId]['price'],
                                          totalPrice: totalprice,
                                          isDeal: 0,
                                          dealId: null,
                                          quantity: _counter,
                                          sizeId: productSizesDetails[selectedSizeId]['size']['id'],//sizes[selectedSizeId].id,
                                          sizeName: selectedSize,
                                          storeId: widget.productDetails.storeId,
                                          topping: encoded))
                                          .then((isInserted) {
                                        if (isInserted > 0) {
                                          Utils.showSuccess(context, "Added to Cart successfully");
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                        }
                                        else {
                                          Utils.showError(
                                              context, "Some Error Occur");
                                        }
                                      });
                                    }else{
                                      Utils.showError(context, "Please Select Same Restaurant Food");
                                    }
                                  }else{
                                      sqlite_helper().create_cart(CartItems(
                                          productId: productId,
                                          productName: widget.productDetails.name,
                                          price: widget.productDetails.productSizes[selectedSizeId]['discountId']!=null?
                                          widget.productDetails.productSizes[selectedSizeId]['discountedPrice']:
                                          widget.productDetails.productSizes[selectedSizeId]['price'],
                                          totalPrice: totalprice,
                                          isDeal: 0,
                                          dealId: null,
                                          quantity: _counter,
                                          sizeId: productSizesDetails[selectedSizeId]['size']['id'],//sizes[selectedSizeId].id,
                                          sizeName: selectedSize,
                                          storeId: widget.productDetails.storeId,
                                          topping: encoded))
                                          .then((isInserted) {
                                        if (isInserted > 0) {
                                          Utils.showSuccess(context, "Added to Cart successfully");
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));
                                        }
                                        else {
                                          Utils.showError(
                                              context, "Some Error Occur");
                                        }
                                      });
                                  }
                                }
                                else{
                               Utils.showError(context, "Error Please Try Again");
                                }
                              } // Navigator.push(context, MaterialPageRoute(builder: (context) => MyCartScreen(),));
                            },
                          ),
                        ],
                      ),
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
