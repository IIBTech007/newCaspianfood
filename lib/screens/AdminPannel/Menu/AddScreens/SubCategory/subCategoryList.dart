import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Categories.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/addProduct.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/Product/productList.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/addSubcategory.dart';
import 'package:capsianfood/screens/AdminPannel/Menu/AddScreens/SubCategory/updateSubCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';



class subCategoryList extends StatefulWidget {
  var categoryId,storeId;

  subCategoryList(this.storeId,this.categoryId);

  @override
  _categoryListPageState createState() => _categoryListPageState();
}


class _categoryListPageState extends State<subCategoryList>{
  String token;
   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  // bool isVisible=false;
  List<Categories> subCategoryList=[];
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
    networksOperation.getSubcategories(context, widget.categoryId).then((value){
      setState(() {
        subCategoryList = value;
        print(widget.categoryId);
        print(value);
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
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          centerTitle: true,
          backgroundColor: BackgroundColor,
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PrimaryColor,size:25),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>add_Subcategory(widget.categoryId)));              },
            ),
          ],

          title: Text("Sub Category", style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: (){
            return Utils.check_connectivity().then((result){
              if(result){
                networksOperation.getSubcategories(context, widget.categoryId).then((value){
                  setState(() {
                    subCategoryList = value;
                    print(widget.categoryId);
                    print(value);
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
                child: ListView.builder(scrollDirection: Axis.vertical, itemCount:subCategoryList == null ? 0:subCategoryList.length, itemBuilder: (context,int index){
                  return Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 70,
                         // padding: EdgeInsets.only(top: 8),
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
                                caption: 'Update',
                                onTap: () async {
                                  print(subCategoryList[index].id);
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>update_SubCategory(widget.categoryId,subCategoryList[index])));
                                },
                              ),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListTile(
                                title: Text(subCategoryList[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: yellowColor),),
                                leading: Image.network(subCategoryList[index].image!= null?subCategoryList[index].image:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",fit: BoxFit.fill,height: 50,width: 50,),
                               onLongPress:(){
                        },
                        onTap: () {
                              print(subCategoryList[index].id);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>productListPage( widget.storeId,widget.categoryId, subCategoryList[index].id,)));
                        },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              )
          ),
        )
    );

  }



  showAlertDialog(BuildContext context,int categoryId,int subcategoryId) {
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
        //Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>productListPage( categoryId, subcategoryId,widget.storeId,)));
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Adding Product"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton(
                child: Text("Add Product"),
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>addProduct( widget.storeId,categoryId, subcategoryId)));
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
}


