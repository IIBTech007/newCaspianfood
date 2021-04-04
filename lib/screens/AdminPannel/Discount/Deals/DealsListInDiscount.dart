import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddDealsWithItems.dart';
import 'UpdateDeals.dart';


class DealsList extends StatefulWidget {
  var discountId,storeId,token;

  DealsList(this.storeId);

  @override
  _DiscountItemsListState createState() => _DiscountItemsListState();
}

class _DiscountItemsListState extends State<DealsList> {
  final Color activeColor = Color.fromARGB(255, 52, 199, 89);
  bool value = false;
  String token;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // // bool isVisible=false;
  List dealsList=[]; List<Products> allProduct=[];
  // bool isListVisible = false;

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
        backgroundColor: BackgroundColor ,
        title: Text('Deals',
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddDeals(widget.storeId)));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              networksOperation.getAllDeals(context, token,widget.storeId).then((value) {
                setState(() {
                  this.dealsList = value;
                  print(dealsList);
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
                itemCount: dealsList==null?0:dealsList.length,
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
                          caption: 'Edit',
                          onTap: () async {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateDeals(dealsList[index],widget.storeId)));
                          },
                        ),

                      ],
                      child: Container(
                       // height: 100,
                        decoration: BoxDecoration(
                          color: BackgroundColor,
                          border: Border.all(color: yellowColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: ListTile(
                          leading: Image.network(dealsList[index]['image']!=null?dealsList[index]['image']:'http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg',fit: BoxFit.cover,height: 90,width: 60,),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dealsList[index]['name'],  style: TextStyle(
                                color: yellowColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text("Actual Price: ${dealsList[index]['actualPrice'].toString()}", style: TextStyle(
                                    color: PrimaryColor,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ),Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text("Discount Price: ${dealsList[index]['price'].toString()}", style: TextStyle(
                                    color: PrimaryColor,
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(' ${dealsList[index]['description'].toString()}',  style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                                ),

                              ),

                            ],
                          ),
                          // trailing: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Text("Actual Price: ${dealsList[index]['actualPrice'].toString()}", style: TextStyle(
                          //         color: PrimaryColor,
                          //         fontWeight: FontWeight.bold
                          //     ),
                          //     ),Text("Discount Price: ${dealsList[index]['price'].toString()}", style: TextStyle(
                          //         color: PrimaryColor,
                          //         fontWeight: FontWeight.bold
                          //     ),
                          //     ),
                          //   ],
                          // ),
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
