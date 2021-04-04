import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'AddDiscount.dart';
import 'ProductsInDiscount/ProductListInDiscount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UpdateDiscounts.dart';



class DiscountItemsList extends StatefulWidget {
  var storeId;

  DiscountItemsList(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<DiscountItemsList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
   String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
   List discountList=[];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    Utils.check_connectivity().then((value) {
      if(value){
      SharedPreferences.getInstance().then((value) {
        setState(() {
          this.token = value.getString("token");
        });
      });
    }else{
      Utils.showError(context, "Please Check Internet Connection");
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
       backgroundColor: BackgroundColor,
       title: Text('Discount Offers',
         style: TextStyle(
           color: yellowColor,
           fontSize: 22,
           fontWeight: FontWeight.bold
       ),
       ),
       centerTitle: true,
       actions: [
         IconButton(
           icon: Icon(Icons.add, color: PrimaryColor,size:25),
           onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> AddDiscount(widget.storeId)));
           },
         ),
       ],
     ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllDiscount(context, token,widget.storeId)
                  .then((value) {
                setState(() {
                  this.discountList = value;
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
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: discountList!=null?discountList.length:0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: Colors.blue,
                          caption: 'Update',
                          onTap: () async {
                            //print(discountList[index]);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateDiscount(discountList[index],widget.storeId)));
                          },
                        ),

                      ],
                      child: Container(
                        height: 95,
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child:
                        ListTile(
                          onTap: (){
                           print(discountList[index]['id'].toString());
                           print(discountList[index]['storeId'].toString());
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>ProductListInDiscount(discountList[index]['id'],widget.storeId,token)));

                          },
                          enabled: discountList[index]['isVisible'],
                          //leading: Image.network(categoryList[index].image!=null?categoryList[index].image:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.fill,height: 50,width: 50,),
                          title: Text(discountList[index]['name'],  style: TextStyle(
                              color: yellowColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                Text('Discount %: ',  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                  Text((discountList[index]['percentageValue']*100).toStringAsFixed(1),  style: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                  ),
                              ],
                              ),
                              SizedBox(height: 5,),
                              Text(discountList[index]['description'].toString(),  style: TextStyle(
                                  color: PrimaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                              ),

                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Start Date: "+discountList[index]['startDate'].toString().substring(0,10), style: TextStyle(
                                color: PrimaryColor,
                                fontWeight: FontWeight.bold
                                 ),
                              ),Text("End Date: "+discountList[index]['endDate'].toString().substring(0,10), style: TextStyle(
                                  color: PrimaryColor,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
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
}
