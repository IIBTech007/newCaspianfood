import 'dart:convert';
import 'dart:typed_data';
import 'package:capsianfood/RequestList/RequestList.dart';
import 'package:capsianfood/RolesBaseStoreSelection.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/helpers/sqlite_helper.dart';
import 'package:capsianfood/model/Additionals.dart';
import 'package:capsianfood/model/BaseSections.dart';
import 'package:capsianfood/model/OrderById.dart';
import 'package:capsianfood/model/Orders.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/model/StockItems.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:capsianfood/model/Tax.dart';
import 'package:capsianfood/model/Vouchers.dart';
import 'package:capsianfood/screens/AdminPannel/AdminNavBar/AdminNavBar.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/RestaurantList/RestaurantMainList.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Store/NewStores.dart';
import 'package:capsianfood/screens/CutomerPannel/ClientNavBar/ClientNavBar.dart';
import 'package:country_provider/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Categories.dart';
import '../model/Products.dart';

class networksOperation{

//  static Future<String> Sign_In(String email,String password) async{
//    Map<String,String> headers = {'Content-Type':'application/json'};
//    final body = jsonEncode({"email":email,"password":password});
//    final response = await http.post('http://192.236.147.77:9000/api/account/login',
//      headers: headers,
//      body: body,
//    );
//    print(response.body);
//    if(response.statusCode==200) {
//      return response.body;
//    }else
//      return null;
//  }

  /// Accounts

 static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  ///Employees

 static Future<bool> addEmployees(BuildContext context,dynamic employeeData) async {
   ProgressDialog pd=ProgressDialog(context);
   pd.show();
   var body=jsonEncode(employeeData);
   try{
     var response=await http.post(Utils.baseUrl()+"account/register",body:body,headers: {"Content-type":"application/json"});
     print(response.body);
     print(response.statusCode.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Register Successfully");
       return true;
     }else if(response.body!=null){
       pd.hide();
       Utils.showError(context, response.body);
       return false;
     }else{

       pd.hide();
       Utils.showError(context, "Some Error");
       return false;
     }
   }catch(e) {
     pd.hide();
     Utils.showError(context, e.toString());
     return false;
   }
 }
 static Future<List> getAllEmployeesByStoreId(BuildContext context,int storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '};
     var response=await http.get(Utils.baseUrl()+"Store/GetAllEmployeesByStoreId/"+storeId.toString(),);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;

     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }

 ///Accounts

  static Future<bool> signUp(BuildContext context,String firstName,String lastName,String email,String password,String address,String cellNo) async {
    ProgressDialog pd=ProgressDialog(context);
    pd.show();
    var body=jsonEncode({"firstname":firstName,
      "lastname":lastName,
      "email":email,
      "password":password,
      "confirmpassword":password,
      "address":address,
      "postcode":"aaa",
      "cellNo":cellNo,
      "country":"Abc",
      "city":address,
      //"storeid":"1",
      "roleid":9});
    try{
      var response=await http.post(Utils.baseUrl()+"account/register",body:body,headers: {"Content-type":"application/json"});
      print(response.body);
      print(response.statusCode.toString());
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Register Successfully");
        return true;
      }else if(response.body!=null){
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }else{

        pd.hide();
        Utils.showError(context, "Some Error");
        return false;
      }
    }catch(e) {
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }
  }
  static void signIn(BuildContext context,String email,String password,String admin) async {
    ProgressDialog pd=ProgressDialog(context);
    pd.show();
    var body=jsonEncode({"email":email,"password":password});
    try{
      List rolesAndStores =[],restaurantList=[];
      bool isCustomer =true;
      print("gfdfghjk");
      var response=await http.post(Utils.baseUrl()+"account/login",body:body,headers: {"Content-type":"application/json"});
      print(response.body);
      if(response!=null&&response.statusCode==200){
        pd.hide();
       List decoded = jsonDecode(response.body)['roles'];
       rolesAndStores.clear();
       restaurantList.clear();
        for(int i=0;i<decoded.length;i++){
          rolesAndStores.add(decoded[i]);
          restaurantList.add(decoded[i]['restaurant']);
        }
        print(rolesAndStores);
        var claims = Utils.parseJwt(jsonDecode(response.body)['token']);
        SharedPreferences.getInstance().then((prefs){
          prefs.setString("token", jsonDecode(response.body)['token']);
          prefs.setString("email", email);
          prefs.setString('userId', claims['nameid']);
          prefs.setString('nameid', claims['nameid']);
             // prefs.setString('isCustomer', claims['IsCustomerOnly']);


        });
        Utils.showSuccess(context, "Login Successful");
        print(claims['IsCustomerOnly'].toString()+"vfdgfdgfdgfdgdfgd");
        if(claims['IsCustomerOnly'] == "false"){
          if(decoded[0]['roleId']== 1){

            Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (context) => DashboardScreen()), (
                MaterialPageRoute(builder: (context) => RequestList(1)), (
                    Route<dynamic> route) => false);
          }
          else if(decoded[0]['roleId']==2){
            Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (context) => DashboardScreen()), (
                MaterialPageRoute(builder: (context) => AdminNavBar(1,2)), (
                    Route<dynamic> route) => false);
          }
          else{
            Navigator.pushAndRemoveUntil(context,
                //MaterialPageRoute(builder: (context) => DashboardScreen()), (
                MaterialPageRoute(builder: (context) => RoleBaseStoreSelection(rolesAndStores)), (
                    Route<dynamic> route) => false);
          }

        }else{
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => ClientNavBar()), (
                  Route<dynamic> route) => false);
        }
        print(response.body);
        }
      // else if(response.body!=null){
      //   pd.hide();
      //   Utils.showError(context, "Try Again");
      // }
      else{
        pd.hide();
        Utils.showError(context, "Please try Again");
      }
    }catch(e) {
      pd.hide();
      print(e.toString());
      Utils.showError(context, "Error Found");
    }
  }
 static Future<dynamic> getRoles(BuildContext context)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Account/GetAllRolesExceptSuperAdmin",);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: ");
   }
   return null;
 }
  static Future<bool> addRole (BuildContext context, String token, String role_name) async {
    ProgressDialog pd=ProgressDialog(context);
    pd.show();
    try{
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "name":role_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(Utils.baseUrl()+'account/AddRole', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }
    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<dynamic> getCustomerById(BuildContext context,String token,int Id)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/GetUserById/"+Id.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }

  ///Client Side Lists

  static Future<List<Categories>> getCategories(BuildContext context,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

  try{
   // pd.show();
    var response=await http.get(Utils.baseUrl()+"Categories/GetAll/$storeId/0",);//0 is for time limitation
    var data= jsonDecode(response.body);
    if(response.statusCode==200){
      pd.hide();
      List<Categories> list=List();
      list.clear();
      for(int i=0;i<data.length;i++){
        list.add(Categories(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],isSubCategoriesExist: data[i]['isSubCategoriesExist'],storeId: data[i]['storeId']));
      }
      //print(data.toString());
      return list;
    }else{
     pd.hide();
      Utils.showError(context, response.body);
    }
  }catch(e){
    pd.hide();
    print(e);
    Utils.showError(context, e.toString());
  }
  //pd.hide();
  return null;
}
  static Future<List<Categories>> getSubcategories(BuildContext context,int categoryId)async{
  try{
    var response=await http.get(Utils.baseUrl()+"subcategories/getbycategoryid/"+categoryId.toString(),);
    var data= jsonDecode(response.body);
    if(response.statusCode==200){
      List<Categories> list=List();
      list.clear();
      for(int i=0;i<data.length;i++){
        list.add(Categories(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],));
      }
      // print(data.toString());
      return list;
    }
    else{
      Utils.showError(context, "Error Occur");
    }
  }catch(e){
    print(e);
    Utils.showError(context, e.toString());
  }
  return null;
}
 // static Future<dynamic> getProductById(BuildContext context,String token,int Id)async{
 //
 //   try{
 //     Map<String,String> headers = {'Authorization':'Bearer '+token};
 //     var response=await http.get(Utils.baseUrl()+"Products/"+Id.toString(),headers: headers);
 //     var data= jsonDecode(response.body);
 //     if(response.statusCode==200 && data!=null){
 //       return data;
 //     }
 //     else{
 //       Utils.showError(context, response.statusCode.toString());
 //       return null;
 //     }
 //   }catch(e){
 //     print(e);
 //     Utils.showError(context, "Error Found: $e");
 //   }
 //   return null;
 // }
  static Future<List<Products>> getProduct(BuildContext context,int categoryId,subCategoryId,int storeId)async{
  try{
    var response=await http.get(Utils.baseUrl()+"Products/GetByCategoryId/$storeId/"+categoryId.toString()+"/"+subCategoryId.toString(),);
    var data= jsonDecode(response.body);
    if(response.statusCode==200){
      print(data);
      List<Products> list=List();
      list.clear();
      for(int i=0;i<data.length;i++){
        list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
            subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
        description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
      }
      print(data.toString());
      return list;
    }
    else{
      Utils.showError(context, response.body);
      print(response.body.toString());
    }
  }catch(e){
    print(e);
    Utils.showError(context, e.toString());
  }
  return null;
}
  static Future<List<Products>> getAllProducts(BuildContext context,int storeId)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString()+"/0/0",);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        print(data);
        List<Products> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
              subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
              description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
        }
        print(data.toString());
        return list;
      }
      else{
        print(response.statusCode.toString());
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
 static Future<List<Products>> getAllProductsWithTime(BuildContext context,int storeId)async{
   try{
     var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString()+"/0/1",);//where 0 is number of trending days & 1 is for time bound
     var data= jsonDecode(response.body);
     if(response.statusCode==200){
       print(data);
       List<Products> list=List();
       list.clear();
       for(int i=0;i<data.length;i++){
         list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
             subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
             description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
       }
       print(data.toString());
       return list;
     }
     else{
       print(response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, e.toString());
   }
   return null;
 }
 static Future<List<Products>> getAllProductsOfAllStore(BuildContext context)async{
   try{
     var response=await http.get(Utils.baseUrl()+"Products/GetAll/0",);
     var data= jsonDecode(response.body);
     if(response.statusCode==200){
       print(data);
       List<Products> list=List();
       list.clear();
       for(int i=0;i<data.length;i++){
         list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
             subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
             description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
       }
       print(data.toString());
       return list;
     }
     else{
       print(response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, e.toString());
   }
   return null;
 }
 static Future<List<Products>> getAllTrending(BuildContext context,String days)async{
   try{
     var response=await http.get(Utils.baseUrl()+"Products/GetAll/0/"+days+"/1");
     var data= jsonDecode(response.body);
     if(response.statusCode==200){
       print(data);
       List<Products> list=List();
       list.clear();
       for(int i=0;i<data.length;i++){
         list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
             subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
             description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
       }
       print(data.toString());
       return list;
     }
     else{
       Utils.showError(context, "Please Try Again");
       print(response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Occur");
   }
   return null;
 }
 static Future<List<Products>> getTrending(BuildContext context,int storeId,int days)async{
   try{
     var response=await http.get(Utils.baseUrl()+"Products/GetAll/"+storeId.toString()+"/"+days.toString()+"/1",);
     var data= jsonDecode(response.body);
     if(response.statusCode==200){
       print(data);
       List<Products> list=List();
       list.clear();
       for(int i=0;i<data.length;i++){
         list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
             subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
             description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
       }
       print(data.toString());
       return list;
     }
     else{
       print(response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, e.toString());
   }
   return null;
 }
  static Future<Products> getProductById(BuildContext context,int productId)async{
    try{
      var response=await http.get(Utils.baseUrl()+"Products/"+productId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        print(data);
        Products productDetails;
        productDetails = Products(name: data['name'],id: data['id'],image: data['image'], subCategoryId: data['subCategoryId'],
            isVisible: data['isVisible'], description: data['description'], storeId: data['storeId'],categoryId: data['categoryId'],productSizes: data['productSizes']);
        print(data.toString());
        return productDetails;
      }
      else{
        print(response.statusCode.toString());
      }
    }catch(e){
      print(e);
      Utils.showError(context, e.toString());
    }
    return null;
  }
  static Future<List<Sizes>> getSizes(BuildContext context,int storeId)async{
  // ProgressDialog pd=ProgressDialog(context);
  // pd.show();
  try{
    var response=await http.get(Utils.baseUrl()+"Sizes/GetAll/$storeId",);
    var data= jsonDecode(response.body);
    if(response.statusCode==200 && data!=null){
     // pd.hide();
      List<Sizes> list=List();
      list.clear();
      for(int i=0;i<data.length;i++){
        list.add(Sizes(name: data[i]['name'],categoryId: data[i]['categoryId'],
            id: data[i]['id'],subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible']));
      }
     // print(data.toString());
      return list;
    }
    else{
    //  pd.hide();
      Utils.showError(context, response.statusCode.toString());
    }
  }catch(e){
    print(e);
    Utils.showError(context, "Error Found: $e");
  }
  return null;
}
  static Future<List<Additionals>> getAdditionals(BuildContext context,String token,int productId,int sizeId)async{
  ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
  try{
    Map<String,String> headers = {'Authorization':'Bearer '+token};
    var response=await http.get(Utils.baseUrl()+"additionalitems/GetAdditionalItemsByCategorySizeProductId/0/"+"$sizeId/"+productId.toString(),headers: headers);
    var data= jsonDecode(response.body);
    if(response.statusCode==200){
      pd.hide();
      return Additionals.listAdditionalsFromJson(response.body);
    }
    else{
      pd.hide();
      Utils.showError(context, response.statusCode.toString());
    }
  }catch(e){
    print(e);
    Utils.showError(context, e.toString());
  }
  return null;
}
 static Future<List<Additionals>> getAdditionalsByProductId(BuildContext context,String token,int productId)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"additionalitems/GetAdditionalItemsByCategorySizeProductId/0/0/"+productId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data.toString()+"Addiotalllllllllllllllll");
     if(response.statusCode==200){
       pd.hide();
       // List<Additionals> list=List();
       // list.clear();
       // for(int i=0;i<data.length;i++){
       //   list.add(Additionals(name: data[i]['name'],price: data[i]['price'],categoryId: data[i]['categoryId'],
       //       id: data[i]['id'],stockItemId: data[i]['stockItemId'],
       //       subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible']),);
       // }
       //print(data.toString());
       return Additionals.listAdditionalsFromJson(response.body);
     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, e.toString());
   }
   return null;
 }

 static Future<List<Additionals>> getAllAdditionals(BuildContext context,int productId)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     var response=await http.get(Utils.baseUrl()+"additionalitems/GetByProductId/"+productId.toString(),);
     var data= jsonDecode(response.body);
     print(data.toString()+"Addiotalllllllllllllllll");
     if(response.statusCode==200){
       pd.hide();
       // List<Additionals> list=List();
       // list.clear();
       // for(int i=0;i<data.length;i++){
       //   list.add(Additionals(name: data[i]['name'],price: data[i]['price'],categoryId: data[i]['categoryId'],
       //       id: data[i]['id'],stockItemId: data[i]['stockItemId'],
       //       subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible']),);
       // }
       //print(data.toString());
       return Additionals.listAdditionalsFromJson(response.body);
     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, e.toString());
   }
   return null;
 }
  static Future<List<BaseSections>> getBaseSections(BuildContext context,int productId)async{

    try{
      var response=await http.get(Utils.baseUrl()+"basesection/GetByProductId/"+productId.toString(),);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        List<BaseSections> list=List();
        list.clear();
        for(int i=0;i<data.length;i++){
          list.add(BaseSections(name: data[i]['name'],
              id: data[i]['id'],isVisible: data[i]['isVisible']));
        }
        //print(data.toString());
        return list;
      }
      else{

        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }

  /// Rider & Location
 static Future<bool> updateDriverLocation(BuildContext context,String token,int orderId,int driverId,String address,String latitude,String longitude)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode({
       "orderid": orderId,
       "DriverId": driverId,
       "DriverAddress": address,
       "DriverLongitude": longitude,
       "DriverLatitude": latitude
     }
       // driverLocation
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"orders/UpdateDriverLocation",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Location Updated");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
       print(response.body.toString());
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
   //return null;
 }
  // static Future<bool> updateDriverLocation(BuildContext context,String token,dynamic driverLocation)async {
  //   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
  //   pd.show();
  //   try{
  //     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
  //
  //     var body=jsonEncode({
  //       "orderid": 79,
  //       "DriverId": 6,
  //       "DriverAddress": "Wazirabad Punjab",
  //       "DriverLongitude": "74.1119",
  //       "DriverLatitude": "32.4302"
  //     }
  //     // driverLocation
  //     );
  //     // print(body);
  //     var response=await http.post(Utils.baseUrl()+"orders/UpdateDriverLocation",headers: headers,body: body);
  //     if(response.statusCode==200){
  //       pd.hide();
  //       Utils.showSuccess(context, "Location Updated");
  //       return true;
  //     }
  //     else{
  //       pd.hide();
  //       Utils.showError(context, response.statusCode.toString());
  //       print(response.body.toString());
  //       return false;
  //     }
  //   }catch(e){
  //     print(e);
  //     Utils.showError(context, "Error Found: $e");
  //     return false;
  //   }
  //   //return null;
  // }
  static Future<dynamic> getDriverLocation(BuildContext context,String token,int orderId,int driverId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getdriverlocation/"+orderId.toString()+"/"+driverId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getRiderList(BuildContext context,String token)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"account/getriders",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        pd.hide();
        return data;

      }
      else{
        pd.hide();
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      pd.hide();
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
/// DailySession
 static Future<bool> addDailySession(BuildContext context,String token,dynamic sessionData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         sessionData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"dailysession/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Daily Session Added");
       sqlite_helper().deletecart();
       return true;
     }
     else{
       pd.hide();
       print(response.body);
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
 }
 static Future<dynamic> getDailySessionByStoreId(BuildContext context,String token,int storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"dailysession/getdailysessionno/"+storeId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     // else if(response.statusCode == 401){
     //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
     // }
     else{

       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     var claims= Utils.parseJwt(token);
     // print(claims);
     // print(DateTime.now());
     print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
     if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
       Utils.showError(context, "Token Expire Please Login Again");
       // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
     }else {
       Utils.showError(context, "Error Found: $e");
     }
   }
   return null;
 }
  /// Order

 static Future<bool> placeOrder(BuildContext context,String token,dynamic orderData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         orderData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"orders/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Your Order is Placed");
       sqlite_helper().deletecart();
       return true;
     }
     else{
       pd.hide();
       print(response.body);
       Utils.showError(context, response.body.toString());
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
 }
 static Future<bool> updateOrder(BuildContext context,String token,dynamic orderData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         orderData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"Orders/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Your Order is Placed");
       sqlite_helper().deletecart();
       return true;
     }
     else{
       pd.hide();
       print(response.body);
       Utils.showError(context, response.body.toString());
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
 }
 static Future<bool> changeOrderStatus(BuildContext context,String token,dynamic OrderStatusData)async{

    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
      var body=jsonEncode(
          OrderStatusData
      );
      var response=await http.post(Utils.baseUrl()+"orders/UpdateStatus",headers: headers,body: body);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return true;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return false;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
      return false;
    }
    return null;
  }
 static Future<dynamic> changeOrderItemStatus(BuildContext context,String token,int orderItemId,int statusId)async{

   try{
     Map<String,String> header = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"orders/UpdateOrderItemStatus/"+orderItemId.toString()+"/"+statusId.toString(),headers: header);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
   }
   return null;
 }
 static Future<dynamic> changeOrderStatusToOnWay(BuildContext context,String token,int orderId,int statusId,int driverId)async{

    try{
      Map<String,String> header = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/UpdateStatus/"+orderId.toString()+"/"
          +statusId.toString()+"/"+driverId.toString(),headers: header);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
 static Future<dynamic> removeOrder(BuildContext context,String token,int orderId,int statusId)async{

   try{
     Map<String,String> header = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"orders/DeleteOrderById/"+orderId.toString()+"/"+statusId.toString(),headers: header);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
   }
   return null;
 }
 static Future<bool> payCashOrder(BuildContext context,String token,dynamic payCash)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          payCash
      );
      var response=await http.post(Utils.baseUrl()+"orders/paycash",headers: headers,body: body);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Order Delivered & Cash Paid");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Order not Delivered Some problem");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found: ");
      return false;
    }
    //return null;
  }
 static Future<dynamic> getAllOrderByDriver(BuildContext context,String token,int driverId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Orders/GetAllBasicOrdersByDriverId/"+driverId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
   }
   return null;
 }
 static Future<List<dynamic>> getAllOrders(BuildContext context,String token)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     List list=[];
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"orders/getallbasicorders",headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       pd.hide();
       if(data!=[])
         list=List.from(data.reversed);
       return list;
       //return data;

     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found: $e");
     return null;
   }finally{
     pd.hide();
   }

 }
 static Future<List<dynamic>> getAllOrdersByCustomer(BuildContext context,String token,int storeId)async{
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getallbasicorders/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        pd.hide();
        if(data!=[])
         list=List.from(data.reversed);
        return list;
        //return data;

      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{
        pd.hide();
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      //  var claims= Utils.parseJwt(token);
      // // print(claims);
      //  print(DateTime.now());
      //    print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
      //    if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
      //      Utils.showError(context, "Token Expire Please Login Again");
      //     // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      //    }else {
      //      Utils.showError(context, "Error Found: $e");
      //    }
      pd.hide();
      Utils.showError(context, "Error Found: $e");
      return null;
    }finally{
      pd.hide();
    }

  }
 static Future<dynamic> getAllOrdersWithItemsByOrderStatusId(BuildContext context,String token,int orderStatusId,int storeId)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     List list=[];
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"orders/getallbasicorderswithitems/"+orderStatusId.toString()+"?StoreId="+storeId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       pd.hide();
       if(data!=[])
         list=List.from(data.reversed);
       return list;
     }
     // else if(response.statusCode == 401){
     //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
     // }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     //  var claims= Utils.parseJwt(token);
     // // print(claims);
     //  print(DateTime.now());
     //    print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
     //    if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
     //      Utils.showError(context, "Token Expire Please Login Again");
     //     // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
     //    }else {
     //      Utils.showError(context, "Error Found: $e");
     //    }
     pd.hide();
     Utils.showError(context, "Error Found: $e");
   }
   pd.hide();
   return null;
 }
 static Future<dynamic> getAllOrdersWithItemsByOrderStatusIdCategorized(BuildContext context,String token,int orderStatusId,int categoryId,int storeId)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     List list=[];
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"orders/getallbasicorderswithitems/"+orderStatusId.toString()+"?CategoryId="+categoryId.toString()+"&StoreId="+storeId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       pd.hide();
       if(data!=[])
         list=List.from(data.reversed);
       return list;
     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found: $e");
   }
   pd.hide();
   return null;
 }
 static Future<dynamic> getOrdersByCustomer(BuildContext context,String token)async{

    try{
      List list=[];
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getbasicordersbycustomer",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        //return data;
        if(data!=[])
        list =List.from(data.reversed);
        return list;
      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{

        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
   //  var claims= Utils.parseJwt(token);
   // // print(claims);
   //  print(DateTime.now());
   //    print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
   //    if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
   //      Utils.showError(context, "Token Expire Please Login Again");
   //     // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
   //    }else {
   //      Utils.showError(context, "Error Found: $e");
   //    }
      Utils.showError(context, "Error Found: ");
      }
    return null;
  }
  static Future<OrderById> getOrderById(BuildContext context,String token,int OrderId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"orders/"+OrderId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       // print(response.body);
       //
       // Order orderDetails;//= Order.fromJson(jsonDecode(response.body));
       // orderDetails=Order(orderitems: data['orderItems']);

       //print(orderDetails);
       print(OrderById.OrderFromJson(response.body).orderItems[0].isDeal);
       return OrderById.OrderFromJson(response.body);
     }
     else{

       Utils.showError(context, "Result Not Found");
       return null;
     }
   }catch(e){
       Utils.showError(context, "Error Found:$e");
       return null;
   }

 }
  static Future<dynamic> getItemsByOrderId(BuildContext context,String token,int OrderId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/GetItemsByOrderId/"+OrderId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      // else if(response.statusCode == 401){
      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      // }
      else{

        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      var claims= Utils.parseJwt(token);
      // print(claims);
      // print(DateTime.now());
      print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
      if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
        Utils.showError(context, "Token Expire Please Login Again");
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
      }else {
        Utils.showError(context, "Error Found: $e");
      }
    }
    return null;
  }
  static Future<dynamic> getOrdersBySession(BuildContext context,String token,int sessionId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getbasicordersbysessionid/"+sessionId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
  static Future<dynamic> getOrderBySalesNo(BuildContext context,String token,int salesno)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"orders/getbasicordersbysaleno/"+salesno.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found: $e");
    }
    return null;
  }
 static Future<dynamic> getOrderPaymentByOrderId(BuildContext context,String token,int orderId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Orders/GetOrderPaymentsByOrderId/"+orderId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     // else if(response.statusCode == 401){
     //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
     // }
     else{

       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
     // var claims= Utils.parseJwt(token);
     // // print(claims);
     // // print(DateTime.now());
     // print(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")));
     // if(DateTime.fromMillisecondsSinceEpoch(int.parse(claims['exp'].toString()+"000")).isBefore(DateTime.now())){
     //   Utils.showError(context, "Token Expire Please Login Again");
     //   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
     // }else {
       Utils.showError(context, "Error Found: $e");
    // }
   }
   return null;
 }
 static Future<dynamic> getOrderPaymentOptions(BuildContext context,String token)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Orders/GetPaymentOptionsDropdown",headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{

       Utils.showError(context, response.statusCode.toString());
     }
   }catch(e){
       Utils.showError(context, "Error Found: $e");
   }
   return null;
 }
 static Future<dynamic> getAllChairsByOderId(BuildContext context,String token,int orderId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Orders/GetChairIdsByOrderId/"+orderId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
         print(response.body);
       Utils.showError(context, response.body.toString());
     }
   }catch(e){
     Utils.showError(context, "Error Found: $e");
   }
   return null;
 }
 static Future<dynamic> GetReports(BuildContext context,String token,dynamic bodyDate)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         bodyDate
     );
     var response=await http.post(Utils.baseUrl()+"Orders/GetReportBydates",headers: headers,body: body);
     var data =jsonDecode(response.body);
     if(response.statusCode==200){
       pd.hide();
      // Utils.showSuccess(context, " Get Reports");
       return data;
     }
     else{
       pd.hide();
       Utils.showError(context, "Some Error Occur");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: ");
     return null;
   }
   //return null;
 }
  /// Order Priority
 static Future<bool> addOrderPriority(BuildContext context,String token,dynamic orderData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         orderData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"OrderPriority/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "OrderPriority Added");
       return true;
     }
     else{
       pd.hide();
       print(response.body);
       Utils.showError(context, response.body.toString());
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
 }
 static Future<bool> updateOrderPriority(BuildContext context,String token,dynamic orderData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         orderData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"OrderPriority/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Order Priority Updated");
       sqlite_helper().deletecart();
       return true;
     }
     else{
       pd.hide();
       print(response.body);
       Utils.showError(context, response.body.toString());
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
 }
 static Future<dynamic> getOrderPriorityDropDown(BuildContext context,int storeId)async{

   try{
    // Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"OrderPriority/GetOrderPrioritiesDropdown/"+storeId.toString());
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       print(response.body);
       Utils.showError(context, response.body.toString());
     }
   }catch(e){
     Utils.showError(context, "Error Found: $e");
   }
   return null;
 }
 static Future<List<dynamic>> getAllOrdersPriority(BuildContext context,String token,int storeId)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
    // List list=[];
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"OrderPriority/GetAll/"+storeId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       pd.hide();
       // if(data!=[])
       //   list=List.from(data.reversed);
       return data;
       //return data;

     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found: $e");
     return null;
   }finally{
     pd.hide();
   }

 }
 static Future<List<dynamic>> getOrdersPriorityById(BuildContext context,String token,int id)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     List list=[];
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"OrderPriority/"+id.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       pd.hide();
       // if(data!=[])
       //   list=List.from(data.reversed);
       // return list;
       return data;

     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found: $e");
     return null;
   }finally{
     pd.hide();
   }

 }

 ///Add

  static Future<bool> addCategory (BuildContext context, String token, dynamic category) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(category
//       {
//         "storeid" : id,
//         "name":category_name,
//         "image":category_image,
//         "StartTime":start_time.toString().substring(10,16),
//         "EndTime": end_time.toString().substring(10,16),
// //      "CreatedBy": createdby,
// //      "createdOn": DateTime.now(),
// //      "isActive":true
//       },
//       toEncodable: Utils.myEncode
      );
      final response = await http.post(Utils.baseUrl()+'categories/Add', headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateCategory (BuildContext context, String token,dynamic categoryData) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(
        categoryData
//           {
//         "id":id,
//         "storeid" : storeId,
//         "name":category_name,
//         "image":category_image,
// //      "CreatedBy": createdby,
// //      "createdOn": DateTime.now(),
// //      "isActive":true
//       },toEncodable: Utils.myEncode
      );
      final response = await http.post(
          Utils.baseUrl()+'categories/Update', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }
      return null;
    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
 static Future<bool> isCategoryExist(BuildContext context,String token,String name)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"categories/IsNameExist/"+name.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
   return null;
 }
  static Future<List<Categories>> getCategory (BuildContext context, String token,int storeId) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};

      final response = await http.get(Utils.baseUrl()+'Categories/GetAll/$storeId/0', headers: headers,);
      if (response.statusCode == 200) {
        pd.hide();
        //List<Categories> category_list = [];
        print(response.body);
        return Categories.listCategoriesFromJson(response.body);
        // for(int i=0; i<jsonDecode(response.body).length; i++){
        //   category_list.add(Categories.fromJson(jsonDecode(response.body)[i]));
        // }
        // return category_list;
      } else {
        pd.hide();
        Utils.showError(context, response.statusCode.toString());
      }

    }
    catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, e.toString());
    }
   return null;
  }
  static Future<bool> addSubcategory (BuildContext context, String token, int catgoryId, String subcategory_name,var subcategory_image) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "categoryid" : catgoryId,
        "name":subcategory_name,
        "image":subcategory_image,
//      "CreatedBy": createdby,
//      "createdOn": DateTime.now(),
//      "isActive":true
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'subcategories/Add', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }
  }
  static Future<bool> updateSubcategory (BuildContext context, String token, int catgoryId,int id, String subcategory_name,var subcategory_image) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "id":id,
        "categoryid" : catgoryId,
        "name":subcategory_name,
        "image":subcategory_image,
//      "CreatedBy": createdby,
//      "createdOn": DateTime.now(),
//      "isActive":true
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'subcategories/Update', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }
    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }
  }
 static Future<bool> isSubCategoryExist(BuildContext context,String token,String name)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"subcategories/IsNameExist/"+name.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
   return null;
 }
 static Future<bool> addProduct (BuildContext context, String token ,dynamic product) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(
          product
        // "name":productName,
        // "description":description,
        // "storeid":storeId,
        // "categoryId":categoryId,
        // "subCategoryId":subcategoryId,
        // "image": image
      );
      final response = await http.post(
          Utils.baseUrl()+'products/Add', headers: headers,
          body: body
      );
      print(response.body);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, "Error Found");
      print(e.toString());
      return false;
    }

  }
  // static Future<bool> updateProduct (BuildContext context, String token,String categoryId,String subcategoryId,int id, String productName,String description,String storeId,var image) async {
 static Future<bool> updateProduct (BuildContext context, String token,dynamic productData) async {
   ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(
        productData

      //{
        // "id": 12, "name": "500 ml", "description": "", "storeid": 1, "categoryId": 3, "subCategoryId": 6,
        // "productSizes": [{"SizeId": 8, "Price": 10.0}]

        // "id": 12,
        // "name":"Special B.BQ",
        // "description":"B.BQ,Cheese,Olives,Mushroom,Onions,Corns",
        // "storeid":"1",
        // "categoryId":"3",
        // "subCategoryId":"6",
        // "productSizes":[{
        //   "SizeId":1,
        //   "Price":3
        // }]


      //   "id":id,
      //   "name":productName,
      //   "description":description,
      //   "storeid":storeId,
      //   "categoryId":categoryId,
      //   "subCategoryId":subcategoryId,
      //   "image": image
      // },toEncodable: Utils.myEncode
      );
      print(body);
      final response = await http.post(
          Utils.baseUrl()+'products/Update', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      print(e.toString());
      return false;
    }

  }
 static Future<bool> isProductExist(BuildContext context,String token,String name)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Product/IsNameExist/"+name.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
   return null;
 }
 static Future<bool> addSizes (BuildContext context, String token, String size_name,int storeId) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "name":size_name,
        "StoreId": storeId,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'sizes/Add', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      print(e.toString());
      return false;
    }

  }
  static Future<bool> updateSizes (BuildContext context, String token,int id, String size_name) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "id":id,
        "name":size_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'sizes/Update', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      print(e.toString());
      return false;
    }

  }
 static Future<bool> isSizeExist(BuildContext context,String token,String name)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"sizes/IsNameExist/"+name.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
   return null;
 }
  static Future<bool> addBaseSection(BuildContext context, String token, int id, String category_name,var category_image) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "productId" : id,
        "name":category_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'basesection/Add', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateBaseSection(BuildContext context, String token,int id, int productId, String category_name,var category_image) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode({
        "id":id,
        "productId" : productId,
        "name":category_name,
      },toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'basesection/Update', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> addAdditionalItems(BuildContext context, String token,var data) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(data,toEncodable: Utils.myEncode);
      final response = await http.post(Utils.baseUrl()+'additionalitems/Add', headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Added Successfully");
        return true;
      } else {
        pd.hide();
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }
  static Future<bool> updateAdditionalItems(BuildContext context, String token,var data ) async {
    ProgressDialog pd=ProgressDialog(context);

    try{
      pd.show();
      Map<String, String> headers = {'Authorization':'Bearer '+token, 'Content-Type':'application/json'};
      final body = jsonEncode(data,toEncodable: Utils.myEncode);
      final response = await http.post(
          Utils.baseUrl()+'additionalitems/Update', headers: headers,
          body: body
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        pd.hide();
        Utils.showSuccess(context, "Update Successfully");
        return true;
      } else {
        pd.hide();
        print(response.body);
        Utils.showError(context, response.body);
        return false;
      }

    }
    catch(e){
      pd.hide();
      Utils.showError(context, e.toString());
      return false;
    }

  }

  ///Discounts

  static Future<bool> addDiscount(BuildContext context,String token,dynamic discount)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          discount
      );
      // print(body);
      var response=await http.post(Utils.baseUrl()+"discounts/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Discount Offer Added");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<bool> updateDiscount(BuildContext context,String token,dynamic discount)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          discount
      );
      // print(body);
      var response=await http.post(Utils.baseUrl()+"discounts/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Discount Offer Added");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
 static Future<bool> isDiscountExist(BuildContext context,String token,String name)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"discounts/IsNameExist/"+name.toString(),headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found: $e");
     return false;
   }
   return null;
 }
  static Future<dynamic> getDiscountList(BuildContext context,String token,int storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Discounts/GetAllActive/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:$e");
    }
    return null;
  }
  static Future<dynamic> getAllDiscount(BuildContext context,String token,int storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"discounts/getall/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }
  static Future<bool> assignDiscountToProduct(BuildContext context,String token,dynamic discountedProducts)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          discountedProducts
      );
      // print(body);
      var response=await http.post(Utils.baseUrl()+"discounts/AssignDiscountToProductSizes",headers: headers,body: body);
      print(response.body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "products Added in Discounts");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<bool> removeProductFromDiscount(BuildContext context,String token,int productId,int sizeId)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode([{
        "productId": productId,
        "sizeId": sizeId
      }]);
      // print(body);
      var response=await http.post(Utils.baseUrl()+"discounts/RemoveDiscountToProductSizes",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "products remove from Discounts");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<dynamic> getDiscountById(BuildContext context,String token,int discountId)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      // var body=jsonEncode(
      //     discountedProducts
      // );
      // print(body);
      var response=await http.get(Utils.baseUrl()+"discounts/GetAssignedDiscountByDiscountId/"+discountId.toString(),headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200){
        pd.hide();
        return data;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return null;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");

      return null;
    }
    return null;
  }

  ///Deals

  static Future<dynamic> addDeals(BuildContext context,String token,dynamic deals)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
    pd.show();
    try{
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
        deals
      );
      // print(body);
      var response=await http.post(Utils.baseUrl()+"deals/Add",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Deals Added Successfully");
        return response.body;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return body;
      }
    }catch(e){
      pd.hide();

      print(e);
      Utils.showError(context, "Error Found:$e");

      return e;
    }
    return null;
  }
  static Future<bool> updateDeals(BuildContext context,String token,dynamic deals)async {
    ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

    try{
      pd.show();
      Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

      var body=jsonEncode(
          deals
      );
      // print(body);
      var response=await http.post(Utils.baseUrl()+"deals/Update",headers: headers,body: body);
      if(response.statusCode==200){
        pd.hide();
        Utils.showSuccess(context, "Deals Updated Successfully");
        return true;
      }
      else{
        pd.hide();
        Utils.showError(context, "Please Try Again");
        return false;
      }
    }catch(e){
      pd.hide();
      print(e);
      Utils.showError(context, "Error Found:");

      return false;
    }
    return null;
  }
  static Future<dynamic> getDealsList(BuildContext context,String token,int storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"Deals/GetAllActive/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:$e");
    }
    return null;
  }
  static Future<dynamic> getAllDeals(BuildContext context,String token,int storeId)async{

    try{
      Map<String,String> headers = {'Authorization':'Bearer '+token};
      var response=await http.get(Utils.baseUrl()+"deals/GetAll/$storeId",headers: headers);
      var data= jsonDecode(response.body);
      print(data);
      if(response.statusCode==200 && data!=null){
        return data;
      }
      else{
        Utils.showError(context, response.statusCode.toString());
        return null;
      }
    }catch(e){
      print(e);
      Utils.showError(context, "Error Found:");
    }
    return null;
  }

  ///  Tables

 static Future<bool> addTable(BuildContext context,String token,dynamic tableData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
       tableData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"tables/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Table Added Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return false;
   }
   return null;
 }
 static Future<bool> updateTable(BuildContext context,String token,dynamic tableData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
       tableData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"tables/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Table Updated Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:");

     return false;
   }
   return null;
 }
 static Future<dynamic> getTableList(BuildContext context,String token,int storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"tables/GetAll/$storeId",headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:$e");
   }
   return null;
 }
 static Future<dynamic> getTableById(BuildContext context,int tableId)async{

   try{
     //Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"tables/"+tableId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }

 ///Chairs
 static Future<bool> addChair(BuildContext context,String token,dynamic tableData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         tableData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"Tables/AddChair",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Table Added Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:");

     return false;
   }
   return null;
 }
 static Future<bool> updateChairs(BuildContext context,String token,dynamic tableData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         tableData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"Tables/UpdateChair",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Table Updated Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:");

     return false;
   }
   return null;
 }
 static Future<dynamic> getChairsListByTable(BuildContext context,String tableId)async{
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   try{
     pd.show();
     Map<String,String> headers = {'Authorization':'Bearer '};
     var response=await http.get(Utils.baseUrl()+"Tables/GetAllChairsByTableId/$tableId",headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       pd.hide();
       return data;
     }
     else{
       pd.hide();
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:$e");
   }
   return null;
 }
 static Future<dynamic> getChairsById(BuildContext context,int chairId)async{

   try{
     //Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Tables/GetChairById/"+chairId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> getChangeChairsStatus(BuildContext context,int chairId)async{

   try{
     //Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Tables/ChangeChairVisibility/"+chairId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 /// Reservation

 static Future<dynamic> addReservation(BuildContext context,String token,dynamic reservationData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
       reservationData
     );
     var response=await http.post(Utils.baseUrl()+"reservation/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "reservation Added Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       print(response.body);
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
 }
 static Future<bool> updateReservation(BuildContext context,String token,dynamic ReservationData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         ReservationData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"reservation/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "reservation Updated Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:");

     return false;
   }
   return null;
 }
 static Future<dynamic> getAvailableTable(BuildContext context,String token,dynamic reservationData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reservationData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"reservation/GetAvailableTables",headers: headers,body: body);
     var data= jsonDecode(response.body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Getting Table");
       return data;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> getReservationList(BuildContext context,String token,int storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"reservation/$storeId",headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:$e");
   }
   return null;
 }
 static Future<dynamic> getReservationByCustomerId(BuildContext context,String token,int customerId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"reservation/GetByCustomerId/$customerId",headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:$e");
   }
   return null;
 }
 static Future<dynamic> getReservationById(BuildContext context,String token,customerId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"reservation/"+customerId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> changeReservationStatus(BuildContext context,String token,int reservationId,statusId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Reservation/UpdateStatus/"+reservationId.toString()+"/"+statusId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> reservationVerification(BuildContext context,String token,int reservationId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Reservation/Verify/"+reservationId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
     return null;
   }

 }
 static Future<dynamic> getReservationDropdown(BuildContext context,String token)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Reservation/GetReservationStatusDropdown",headers: headers);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:$e");
   }
   return null;
 }
 ///Reviews

 static Future<dynamic> addReviews(BuildContext context,String token,dynamic reviewsData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reviewsData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"ProductsFeedBack/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Reviews Added Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> updateReviews(BuildContext context,String token,dynamic reviewsData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reviewsData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"ProductsFeedBack/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Reviews Update Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return body;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return e;
   }
   return null;
 }
 static Future<dynamic> getReviewsByProductId(BuildContext context,String token,productId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"ProductsFeedBack/GetByProductId/"+productId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> getAllReviews(BuildContext context,String token)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"ProductsFeedBack/GetAll",headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }

 ///OrderFeedBack

 static Future<dynamic> addFeedBack(BuildContext context,String token,dynamic reviewsData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reviewsData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"OrderFeedBack/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Reviews Added Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       print(response.statusCode.toString());
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> updateFeedback(BuildContext context,String token,dynamic reviewsData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reviewsData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"OrderFeedBack/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "FeedBack Update Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context,"Please Try Agian");
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> getFeedBackOrderId(BuildContext context,String token,int orderId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"OrderFeedBack/GetByOrderId/"+orderId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> getFeedBackByCustomerId(BuildContext context,String token,customerId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"OrderFeedBack/GetByOrderId/"+customerId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> getAllFeedBack(BuildContext context,String token,int storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"OrderFeedBack/GetAll/$storeId");
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 ///StoreFeedBack

 static Future<dynamic> addStoreFeedBack(BuildContext context,String token,dynamic reviewsData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reviewsData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"StoreFeedback/Add",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Reviews Added Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       print(response.statusCode.toString());
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> updateStoreFeedback(BuildContext context,String token,dynamic reviewsData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         reviewsData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"StoreFeedback/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "FeedBack Update Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context,"Please Try Agian");
       return null;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> getAllStoreFeedBack(BuildContext context,String token,int storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"StoreFeedback/GetAll/$storeId");
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
///Restaurant

 static Future<bool> addRestaurant(BuildContext context,var restaurantData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json'};

     var body=jsonEncode(
         restaurantData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"account/register",body: body,headers: headers);
     print(response.body);
     var data = response.body;
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Request Added Successfully");
       return true;
     }
     else{
       pd.hide();
        print("data['errors']");
        Utils.showError(context, data!=null?data:"Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:");

     return false;
   }
   return null;
 }
 static Future<dynamic> updateRestaurant(BuildContext context,String token,dynamic restaurantData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         restaurantData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"Restaurant/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Reviews Update Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return body;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return e;
   }
   return null;
 }
 static Future<dynamic> getRestaurantById(BuildContext context,String token,restaurantId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Restaurant/"+restaurantId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> getAllRestaurant(BuildContext context)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '};
     var response=await http.get(Utils.baseUrl()+"Restaurant/Get",);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> restaurantVisibility(BuildContext context,String token,restaurantId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Restaurant/ChangeVisibility/"+restaurantId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> changeRestaurantStatus(BuildContext context,String token,restaurantId,int statusId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Restaurant/ChangeStatus/"+restaurantId.toString()+"/"+statusId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }

 ///Stores

 static Future<dynamic> addStore(BuildContext context,String token,dynamic storeData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
        storeData
     );
     var response=await http.post(Utils.baseUrl()+"Store/Add",body: body,headers: headers);
     print(response.statusCode.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Store Added Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     pd.hide();
    print("djdkbcbdchjd");
     print(e);
     Utils.showError(context, "Error Found:$e");

     return null;
   }
   return null;
 }
 static Future<dynamic> updateStore(BuildContext context,String token,dynamic storeData)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     var body=jsonEncode(
         storeData
     );
     // print(body);
     var response=await http.post(Utils.baseUrl()+"Store/Update",headers: headers,body: body);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Store Update Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return body;
     }
   }catch(e){
     pd.hide();

     print(e);
     Utils.showError(context, "Error Found:$e");

     return e;
   }
   return null;
 }
 static Future<Store> getStoreById(BuildContext context,String token,storeId)async{

   try{
     //Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Store/"+storeId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return Store.StoreFromJson(response.body);
     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Store>> getAllStoresByRestaurantId(BuildContext context,dynamic storeData)async{

   try{
     var body=jsonEncode(
         storeData
     );
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '};
     var response=await http.post(Utils.baseUrl()+"Store/GetAll",headers:headers,body: body );
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       //return data;
       // List<Store> list=List();
       // list.clear();
       // for(int i=0;i<data.length;i++){
       //   list.add(Store(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
       //       address:  data[i]['address'],isVisible: data[i]['isVisible'],
       //       city:  data[i]['city'],restaurantId: data[i]['restaurantId'],));
       // }
       // print(data.toString());
       // return list;
       return Store.listStoreFromJson(response.body);

     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Store>> getAllStore(BuildContext context,storeData)async{

   try{
     var body=jsonEncode(
         storeData
     );
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '};
     var response=await http.post(Utils.baseUrl()+"Store/GetAll",body: body,headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       //return data;
       // List<Store> list=List();
       // list.clear();
       // for(int i=0;i<data.length;i++){
       //   list.add(Store(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
       //       address:  data[i]['address'],isVisible: data[i]['isVisible'],
       //       city:  data[i]['city'],restaurantId: data[i]['restaurantId'],));
       // }
       // print(data.toString());
       // return list;
       return Store.listStoreFromJson(response.body);

     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Products>> getAllProductBySearch(BuildContext context,storeData)async{

   try{
     var body=jsonEncode(
         storeData
     );
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '};
     var response=await http.post(Utils.baseUrl()+"Store/GetAll",body: body,headers: headers);
     var data= jsonDecode(response.body);
     print(data);
   //  print(Products.listProductFromJson(data).toString());
     if(response.statusCode==200 && data!=null){
       //return data;
       List<Products> list=List();
       list.clear();
       for(int i=0;i<data.length;i++){
         list.add(Products(name: data[i]['name'],id: data[i]['id'],image: data[i]['image'],
             subCategoryId: data[i]['subCategoryId'],isVisible: data[i]['isVisible'],
             description: data[i]['description'],storeId: data[i]['storeId'],categoryId: data[i]['categoryId'],productSizes: data[i]['productSizes']));
       }
        print(list.toString());
        return list;

       //return Products.listProductFromJson(response.body);

     }
     else{
       Utils.showError(context, "Please Try Agian");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> storeVisibility(BuildContext context,String token,storeId)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"Store/ChangeVisibility/"+storeId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, "Please Try Agian");
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
     return false;
   }

 }

/// Tax

 static Future<dynamic> addTax(BuildContext context,String token,dynamic taxBody)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);

   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     // var body=jsonEncode(
     //     storeData
     // );
     var response=await http.post(Utils.baseUrl()+"Taxes/Add",body: taxBody,headers: headers);
     print(response.body.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Tax Added Successfully");
       return response.body;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found:");

     return null;
   }
   return null;
 }
 static Future<dynamic> updateTax(BuildContext context,String token,dynamic taxBody)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};

     // var body=jsonEncode(
     //     storeData
     // );
     var response=await http.post(Utils.baseUrl()+"Taxes/Update",headers: headers,body: taxBody);
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Tax Update Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:");
     return null;
   }
 }
 static Future<Tax> getTaxById(BuildContext context,int taxId)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Taxes/"+taxId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return Tax.taxFromJson(response.body);
     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Tax>> getTaxListByStoreId(BuildContext context,int storeId )async{

   try{
     var response=await http.get(Utils.baseUrl()+"Taxes/GetAll/"+storeId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return Tax.taxListFromJson(response.body);

     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Tax>> getTaxListByStoreIdWithOrderType(BuildContext context,int storeId,int orderType)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Taxes/GetAll/"+storeId.toString()+"/$orderType");
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return Tax.taxListFromJson(response.body);

     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<bool> TaxVisibility(BuildContext context,int taxId)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Taxes/ChangeVisibility/"+taxId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, "Please Try Agian");
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
     return false;
   }

 }

 /// Vouchers

 static Future<bool> addVoucher(BuildContext context,String token,dynamic Body)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
     var response=await http.post(Utils.baseUrl()+"Vouchers/Add",body: Body,headers: headers);
     print(response.body.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Vocher Added Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found:");

     return false;
   }
 }
 static Future<bool> updateVoucher(BuildContext context,String token,dynamic taxBody)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
     var response=await http.post(Utils.baseUrl()+"Vouchers/Update",headers: headers,body: taxBody);
     print(response.body);
     print(response.statusCode.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Voucher Update Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:");
     return false;
   }
 }
 static Future<Voucher> getVoucherById(BuildContext context,int taxId)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Vouchers/"+taxId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return Voucher.voucherFromJson(response.body);
     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Voucher>> getVoucherListByStoreId(BuildContext context,int storeId )async{

   try{
     var response=await http.get(Utils.baseUrl()+"Vouchers/GetAll/"+storeId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return Voucher.voucherListFromJson(response.body);

     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<dynamic> checkVoucherValidity(BuildContext context,String code,double netTotal)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Vouchers/CheckValidity/"+code+"/"+netTotal.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return data;

     }
     else{
       Utils.showError(context, data['message'].toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<bool> voucherVisibility(BuildContext context,int voucherId)async{

   try{
     var response=await http.get(Utils.baseUrl()+"Vouchers/ChangeVisibility/"+voucherId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return true;
     }
     else{
       Utils.showError(context, "Please Try Agian");
       return false;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
     return false;
   }

 }

/// Stock

 static Future<bool> addStockItem(BuildContext context,String token,dynamic Body)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   try{
     pd.show();
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
     var response=await http.post(Utils.baseUrl()+"ItemStocks/Add",body: Body,headers: headers);
     print(response.body.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Stock Added Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     Utils.showError(context, "Error Found:");

     return false;
   }
 }
 static Future<bool> updateStockItem(BuildContext context,String token,dynamic stock)async {
   ProgressDialog pd = ProgressDialog(context,type: ProgressDialogType.Normal);
   pd.show();
   try{
     Map<String,String> headers = {'Content-Type':'application/json','Authorization':'Bearer '+token};
     var response=await http.post(Utils.baseUrl()+"ItemStocks/Update",headers: headers,body: stock);
     print(response.body);
     print(response.statusCode.toString());
     if(response.statusCode==200){
       pd.hide();
       Utils.showSuccess(context, "Voucher Update Successfully");
       return true;
     }
     else{
       pd.hide();
       Utils.showError(context, "Please Try Again");
       return false;
     }
   }catch(e){
     pd.hide();
     print(e);
     Utils.showError(context, "Error Found:");
     return false;
   }
 }
 static Future<StockItems> getStockItemById(BuildContext context,int stockId)async{

   try{
     var response=await http.get(Utils.baseUrl()+"ItemStocks/"+stockId.toString());
     var data= jsonDecode(response.body);
     print(data);
     if(response.statusCode==200 && data!=null){
       return StockItems.StockItemsFromJson(response.body);
     }
     else{
       Utils.showError(context, "Please Try Again");
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<StockItems>> getStockItemsListByStoreId(BuildContext context,String token,int storeId )async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"ItemStocks/Get/"+storeId.toString(),headers: headers);
     var data= jsonDecode(response.body);
     print(data.toString()+"qwertyuhgfdfghjnbvb");
     if(response.statusCode==200){
       return StockItems.StockItemsListFromJson(response.body);

     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }

 static Future<dynamic> getStockUnitsDropDown(BuildContext context,String token )async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '+token};
     var response=await http.get(Utils.baseUrl()+"ItemStocks/GetStockItemUnitsDropdown",headers: headers);
     var data= jsonDecode(response.body);
     print(data.toString()+"qwertyuhgfdfghjnbvb");
     if(response.statusCode==200){
       return data;

     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }


 static Future<dynamic> getCountries(BuildContext context)async{

   try{
     Map<String,String> headers = {'Authorization':'Bearer '};
     var response=await http.get("https://restcountries.eu/rest/v2/all",);
     var data= jsonDecode(response.body);
     if(response.statusCode==200 && data!=null){
       return data;
     }
     else{
       Utils.showError(context, response.statusCode.toString());
       return null;
     }
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
 static Future<List<Country>> getCountriesList(BuildContext context)async{

   try{
     List<Country> countries = await CountryProvider.getAllCountries();
    return countries;
   }catch(e){
     print(e);
     Utils.showError(context, "Error Found:");
   }
   return null;
 }
}
