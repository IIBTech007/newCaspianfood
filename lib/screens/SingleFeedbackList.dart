import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capsianfood/LibraryClasses/feedback_dialog.dart';
import 'package:capsianfood/networks/network_operations.dart';


class SingleFeedBack extends StatefulWidget {
  var orderDetails;

  SingleFeedBack(this.orderDetails);

  @override
  _PastOrdersState createState() => _PastOrdersState();
}

class _PastOrdersState extends State<SingleFeedBack> {
  String token;
  List<Categories> categoryList=[];
  List feedBackList = [];
  var userDetail;
  String userid,storeid;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        userid = value.getString("nameid");
        storeid = value.getString("storeid");
      });
    });
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getFeedBackOrderId(context, token, widget.orderDetails['id']).then((value) {
          setState(() {
            print(value);
            print(widget.orderDetails['id']);
            feedBackList.clear();
            if(value!=null) {
              for (int i = 0; i < value.length; i++) {
                feedBackList.add(value[i]);
              }
            }
            else
              feedBackList =null;

            // print(value.toString());
          });
        });
        networksOperation.getCustomerById(context, token,int.parse(userid)).then((value){
          setState(() {


            userDetail = value;
          });
        });
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
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: feedBackList!=null?feedBackList.length:0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: BackgroundColor,
                        border: Border.all(color: yellowColor, width: 2)
                    ),
                    child: InkWell(
                      onTap: () {

                      },
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            caption: 'Edit',
                            onTap: () async {
                              print(feedBackList[index]['id'].toString());
                              _showRatingDialog(feedBackList[index]['id'],widget.orderDetails['id'],int.parse(userid),int.parse(storeid));
                            },
                          ),

                        ],
                        child: ListTile(
                          trailing:  Column(
                            children: [
                              Container(
                                height: 5,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < int.parse(feedBackList[index]['rating'].toString().replaceAll(".0", "")) ? Icons.star : Icons.star_border,color: yellowColor,
                                    );
                                  }),
                                ),
                              ),

                            ],
                          ),
                          //backgroundColor: Colors.white12,
                          subtitle:

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 50,

                                        child: Text(feedBackList!=null?feedBackList[index]['comments']:null,maxLines: 4,overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: PrimaryColor
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(feedBackList[index]['createdOn'].toString().replaceAll("T", " || ").substring(0,19),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: PrimaryColor
                                  ),
                                ),
                              ),


                            ],
                          ),
                          onTap: () {
                            print(feedBackList[index]);
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(feedBackList[index]['orderId']!=null?'ORDER ID: '+feedBackList[index]['orderId'].toString():"",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: yellowColor
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
        ),
      ),
    );
  }
  _showRatingDialog(int uId,int orderId,int nameId,int storeId) {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return FeedBackDialog(
            icon: Image.asset('assets/caspian11.png'),
            title: "Please Add Ratings",
            submitButton: "SUBMIT",
            productId: orderId,
            customerId: nameId,
            storeId: storeId,
            uId: uId,
            token: token,
            accentColor: yellowColor, // optional
            // onSubmitPressed: (List rating) {
            onSubmitPressed: (int rating) {
              print("onSubmitPressed: rating = $rating");
              // TODO: open the app's page on Google Play / Apple App Store
            },
            onAlternativePressed: () {
              print("onAlternativePressed: do something");
              // TODO: maybe you want the user to contact you instead of rating a bad review
            },
          );
        });
  }

}
