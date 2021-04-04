import 'dart:convert';
import 'dart:ui';
import 'package:capsianfood/CardPayment.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/model/Orderitems.dart';
import 'package:capsianfood/model/Orders.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/model/orderItemTopping.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/SecondryAddress.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../../ClientNavBar/ClientNavBar.dart';

class CheckedoutDetails extends StatefulWidget {
  var orderItems,token,storeId,notes,voucher;
  double netTotal,applyVoucherPrice;

  CheckedoutDetails({this.orderItems,this.netTotal,this.applyVoucherPrice,this.notes,this.voucher,this.token,this.storeId});

  @override
  _CheckedoutDetailsState createState() => _CheckedoutDetailsState();
}

class _CheckedoutDetailsState extends State<CheckedoutDetails> {
  int _groupValue = -1;
  bool isvisible =false;
  int paymentOptionValue;
  String paymentOption;
  Address address;
  String orderType,tableName;int orderTypeId,tableId;
  TextEditingController secondryAddress;
  // List orderTypeList = ["DineIn ","TakeAway ","HomeDelivery "];
  List orderTypeList = ["OnShop","Delivery"];

  List tableDDList=[],allTableList=[];
  String deviceId;
  List<Widget> chairChips=[];
  List<Widget> chips=[];
  List<Orderitem> orderitem=[],orderItems1 = [];
  List orderItemswithChairs=[];
  var latitude,longitude;
  FirebaseMessaging _firebaseMessaging;
  List allChairList =[],chairListForPayment=[],selectedChairListForPayment=[];
  List<String> orderSelectedChairsList = [],countList = [];
  List orderSelectedChairsListIds = [];
  var cardData,dailySession;
  DateTime pickingTime ;
  List<Tax> taxList = [];
  double totalPercentage=0.0,totalTaxPrice=0.0;
  List orderTaxList =[];

  void _openFilterDialog() async {
    await FilterListDialog.display(context,
        allTextList: countList,

        height: 380,
        borderRadius: 20,
        headlineText: "Select Count",
        searchFieldHintText: "Search Here",
        selectedTextList: orderSelectedChairsList, onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              orderSelectedChairsList = List.from(list);
              chairChips.clear();
              orderSelectedChairsListIds.clear();
              chairListForPayment.clear();
              if(orderSelectedChairsList!=null && orderSelectedChairsList.length>0) {
                for (int i = 0; i < orderSelectedChairsList.length; i++) {
                  chairChips.add(Chip(label: Text(orderSelectedChairsList[i])));
                  print(countList.indexOf(orderSelectedChairsList[i]).toString()+"djjkjdhjdhjdhcjdc");
                  orderSelectedChairsListIds.add({
                    "ChairId":allChairList[countList.indexOf(orderSelectedChairsList[i])]['id'],
                  });
                  chairListForPayment.add({
                    'display':allChairList[countList.indexOf(orderSelectedChairsList[i])]['name'],
                    'value':allChairList[countList.indexOf(orderSelectedChairsList[i])]['id']
                  });
                }
              }
            });
            Navigator.pop(context);
          }
        });
  }

  @override
  void initState() {
    print(widget.orderItems.toString()+"bvgfhjkhgfhjgfhjkhgfdghjkhgfdg");
    //setState(() {
      // orderitem.clear();
      // for(int i =0;i<widget.orderItems.length;i++){
      //   orderitem.add(Orderitem(name: widget.orderItems[i]['name'],price: widget.orderItems[i]['price'],
      //       totalprice: widget.orderItems[i]['totalprice'],
      //   quantity: widget.orderItems[i]['quantity'],sizeid:  widget.orderItems[i]['sizeid'],havetopping: widget.orderItems[i]['havetopping'],
      //   productid: widget.orderItems[i]['productid'],IsDeal:  widget.orderItems[i]['IsDeal'],
      //       orderitemstoppings: Orderitemstopping.listProductFromJson(json.encode(widget.orderItems[i]['orderitemstoppings']))));
      //
      // }
   // });
  _firebaseMessaging=FirebaseMessaging();
  _firebaseMessaging.getToken().then((value) {
    setState(() {
      deviceId = value;
    });
    print(value+"hbjhdbjhcbhj");
  });


  print(widget.orderItems);
  secondryAddress = TextEditingController();
  Utils.check_connectivity().then((result) {
    if(result){
      // networksOperation.getStoreById(context, widget.token, widget.storeId).then((value){
      //   if(value!=null){
      //     if(value.dineIn)
      //       orderTypeList.add("Dine In");
      //     if(value.takeAway)
      //       orderTypeList.add("Take Away");
      //     if(value.delivery)
      //     orderTypeList.add("Delivery");
      //   }
      // });
      // networksOperation.getTableList(context, widget.token,widget.storeId).then((value){
      //   setState(() {
      //     allTableList =value;
      //     print(value);
      //     for(int i=0;i<allTableList.length;i++){
      //
      //       tableDDList.add(allTableList[i]['name']);
      //
      //     }
      //     print(tableDDList);
      //   });
      // });
    networksOperation.getDailySessionByStoreId(context, widget.token,widget.storeId).then((value){
      setState(() {
        dailySession =value;
        print(value);
      });
    });
    }
  });



    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text('Checkedout Details', style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
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
        child: new Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          color:BackgroundColor,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: yellowColor, width: 2)
                      ),
                      width: MediaQuery.of(context).size.width*0.98,
                      padding: EdgeInsets.all(14),
                      child:
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Order Type",

                          alignLabelWithHint: true,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color:yellowColor),
                          enabledBorder: OutlineInputBorder(
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color:yellowColor),
                          ),
                        ),

                        value: orderType,
                        onChanged: (Value) {

                          setState(() {
                            orderType = Value;
                            orderTypeId = orderTypeList.indexOf(orderType)+1;
                            print(orderTypeId);
                          });
                        },
                        items: orderTypeList.map((value) {
                          return  DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  value,
                                  style:  TextStyle(color: yellowColor,fontSize: 13),
                                ),
                                //user.icon,
                                //SizedBox(width: MediaQuery.of(context).size.width*0.71,),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: orderType =="Delivery",
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        child: ListTile(
                          title: TextFormField(
                            controller: secondryAddress,
                            style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            obscureText: false,maxLines: 2,
                            decoration: InputDecoration(
                              // suffixIcon: Icon(Icons.add_location,color: Colors.amberAccent,),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor, width: 1.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                              ),
                              labelText: 'Secondary Address',
                              labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                              //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          trailing: InkWell(
                              onTap: () async{
                                address = await Navigator.push(context, MaterialPageRoute(builder: (context) => getPosition(),),);
                               // setState(() {
                               // print(address.latitude+"vbcvnvcnbnc");
                                secondryAddress.text = address.address;
                               // latitude = address.latitude;
                               // });
                                },
                              child: Icon(Icons.add_location,color: yellowColor, size: 35,)),
                        )
                        ),
                      ),
                  ),
                  Visibility(
                    visible: orderType =="OnShop",
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: BackgroundColor,
                      child: FormBuilderDateTimePicker(
                        attribute: "Estimate Picking time",
                        style: Theme.of(context).textTheme.body1,
                        inputType: InputType.time,
                        validators: [FormBuilderValidators.required()],
                        format: DateFormat("hh:mm:ss"),
                        decoration: InputDecoration(labelText: "Estimate Picking time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.0),
                              borderSide: BorderSide(color: yellowColor, width: 2.0)
                          ),),
                        onChanged: (value){
                          setState(() {
                            this.pickingTime=value;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color:BackgroundColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: yellowColor, width: 2)
                        ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Payment Method',style: TextStyle(color: yellowColor,fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                      Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: yellowColor,
                    ),

                      _myRadioButton(
                        title: orderType=="OnShop"?"Cash on Picking ":"Cash On Delivery",
                        value: 1,
                        onChanged: (newValue) => setState(() => _groupValue = newValue,
                        ),
                      ),
                          // _myRadioButton(
                          //   title: "Credit Card",
                          //   value: 2,
                          // //  onChanged: (newValue) => setState(() => _groupValue = newValue,
                          //  // ),
                          //   onChanged: (value)async{
                          //     setState(() async{
                          //       _groupValue = value;
                          //
                          //      cardData = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  CardPayment() ));
                          //     });
                          //   }
                          // ),
                        ],
                      )
                    ),
                  ),
                  Visibility(
                    visible: orderTypeId!=null,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4,left: 4),
                      child: Card(
                        color: BackgroundColor,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: yellowColor, width: 2)

                          ),
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height /2.7 ,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('SubTotal',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    Text(widget.applyVoucherPrice!=null?widget.applyVoucherPrice.toString():widget.netTotal.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: PrimaryColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   height: 100,
                              //   child: ListView.builder(
                              //       padding: EdgeInsets.all(4),
                              //       scrollDirection: Axis.vertical,
                              //       itemCount: taxList != null ? taxList.length : 0,
                              //       itemBuilder: (context, int index) {
                              //         return  Padding(
                              //           padding: const EdgeInsets.only(
                              //               top: 20, left: 10, right: 10),
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Text(
                              //                 taxList[index].name+ " (${taxList[index].percentage.toString()}%)",
                              //                 style: TextStyle(
                              //                     fontSize: 17,
                              //                     fontWeight: FontWeight.bold,
                              //                     color: yellowColor),
                              //               ),
                              //               Text((){
                              //                 if(taxList[index].percentage!=0.0){
                              //                 var tax =  (taxList[index].percentage/100.0)*widget.netTotal;
                              //                 return tax.toStringAsFixed(1);
                              //                 }else if(taxList[index].price!=0.0){
                              //                   return taxList[index].price.toString();
                              //                 }else
                              //                   return "";
                              //                  }(),
                              //                 style: TextStyle(
                              //                     fontSize: 17,
                              //                     fontWeight: FontWeight.bold,
                              //                     color: PrimaryColor),
                              //               ),
                              //             ],
                              //           ),
                              //         );
                              //
                              //       }),
                              // ),




                              // Visibility(
                              //   visible: orderTypeId ==3,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text("taxList",
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: yellowColor
                              //           ),
                              //         ),
                              //         Text(' 00.00',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: PrimaryColor
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Visibility(
                              //   visible: orderTypeId ==1,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text('Service Charges',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: yellowColor
                              //           ),
                              //         ),
                              //         Text(' 00.00',
                              //           style: TextStyle(
                              //               fontSize: 17,
                              //               fontWeight: FontWeight.bold,
                              //               color: PrimaryColor
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, right: 10),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text('Tax(0.0%)',
                              //         style: TextStyle(
                              //             fontSize: 17,
                              //             fontWeight: FontWeight.bold,
                              //             color: yellowColor
                              //         ),
                              //       ),
                              //       Text(' 00.00',
                              //         style: TextStyle(
                              //             fontSize: 17,
                              //             fontWeight: FontWeight.bold,
                              //             color: PrimaryColor
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(padding: EdgeInsets.all(10),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: yellowColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: yellowColor
                                      ),
                                    ),
                                    Text(widget.netTotal.toString(),
                                    //       (){
                                    //   if(totalPercentage ==0.0 && totalTaxPrice ==0.0){
                                    //     return widget.applyVoucherPrice.toString()??widget.netTotal.toString();
                                    //   }
                                    //   else{
                                    //     var taxesAmount = (totalPercentage/100.0)*widget.netTotal;
                                    //     print(taxesAmount.toString()+"qwertyuiopfdsdfghj");
                                    //     var gross  = totalTaxPrice + taxesAmount + (widget.applyVoucherPrice??widget.netTotal);
                                    //     return gross.toString();
                                    //   }
                                    // }(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: PrimaryColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(8),),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: yellowColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                    InkWell(
                      onTap: (){
                         if( orderType =="Delivery"){
                           if(address.toString() ==null){
                             Utils.showError(context, "please select secondry address");
                           }else if(dailySession==null){
                             Utils.showError(context, "Restaurant can't Accept Order This Time");
                           }
                           // else if(_groupValue==2){
                           //   cardData==null??Utils.showError(context, "Please Add Debit / Credit Card");
                           // }
                           else {
                             print("print 3");
                             dynamic order = {
                               "DailySessionNo": dailySession,
                               "StoreId":widget.storeId,
                               "DeviceToken":deviceId,
                               "ordertype":3,
                               "NetTotal":widget.netTotal,
                             //  "grosstotal":widget.netTotal,
                               "comment":widget.notes!=null?widget.notes:null,
                               "TableId":null,
                               "DeliveryAddress" : secondryAddress.text!=null?secondryAddress.text:address.toString()!=null?address.address:null,
                               "DeliveryLongitude" : address!=null?address.longitude:0.0,
                               "DeliveryLatitude" : address!=null?address.latitude:0.0,
                               "PaymentType" : _groupValue,
                               "orderitems":widget.orderItems,
                               "CardNumber": cardData!=null?cardData['CardNumber']:null,
                               "CVV": cardData!=null?cardData['CVV']:null,
                               "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                               "OrderTaxes":orderTaxList,
                               "VoucherCode": widget.voucher,
                               // "MobileNo": "03123456789",
                               // "CnicLast6Digits": "345678"
                             };
                             print(jsonEncode(order));
                             networksOperation.placeOrder(context, widget.token, order).then((value) {
                               if(value){
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));

                               }
                             });
                           }
                         }else if( orderType =="OnShop"){
                          if(_groupValue==2 && cardData==null){
                           Utils.showError(context, "Please Add Debit / Credit Card");
                         }else if(dailySession==null){
                            Utils.showError(context, "Restaurant can't Accept Order This Time");
                          }else if(pickingTime==null){
                            Utils.showError(context, "Please Enter Picking Time");
                          }
                          else{
                            print("print 2");
                            dynamic order = {
                              "DailySessionNo": dailySession,
                              "storeId":widget.storeId,
                              "DeviceToken":deviceId,
                              "ordertype":2,
                              "NetTotal":widget.netTotal,
                            //  "grosstotal":widget.netTotal,
                              "comment":widget.notes,
                              "TableId":null,
                              "DeliveryAddress" : null,
                              "DeliveryLongitude" : null,
                              "DeliveryLatitude" : null,
                              "PaymentType" : _groupValue,
                              "orderitems":widget.orderItems,
                              "CardNumber": cardData!=null?cardData['CardNumber']:null,
                              "CVV": cardData!=null?cardData['CVV']:null,
                              "ExpiryDate": cardData!=null?cardData['ExpiryDate']:null,
                              "EstimatedTakeAwayTime": pickingTime.toString().substring(10,16),
                              "OrderTaxes":orderTaxList,
                              "VoucherCode": widget.voucher,
                              // "MobileNo": "03123456789",
                              // "CnicLast6Digits": "345678"
                            };
                            print(jsonEncode(order));
                            networksOperation.placeOrder(context, widget.token, order).then((value) {
                              if(value){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientNavBar()));

                              }
                            });
                          }

                         }
                         else{
                           Utils.showError(context, "Error Occur");
                         }

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          color: yellowColor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height  * 0.08,

                        child: Center(
                          child: Text('Submit Order',style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      activeColor: yellowColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(
          color: PrimaryColor,
          fontSize: 17,
          fontWeight: FontWeight.bold

      ),),
    );
  }


}