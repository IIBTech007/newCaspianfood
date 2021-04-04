import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/SecondryAddress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:country_provider/country_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';




class AddStore extends StatefulWidget {
  var restaurantId;

  AddStore(this.restaurantId);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AddStore> {
  List countries = ["Pakistani","Indian","American","Italian","Turkish","Chinese"];
  List currencies =["\$","€"," د.إ","₨","£","﷼"];
  String selectedCurrency;
  String selectedCuisine;
  Address address;
  TextEditingController storeName,city,postCode,contactNo,storeAddress;
  bool deliveryVal = false;
  bool pickUpVal = false;
  bool dineInVal = false;
  String token;
  static const orange = Color(0xFFFE9A75);
  static const dark = Color(0xFFFFAB00);
  static const double leftPadding = 50;
  DateTime start_time ;//= DateTime.now();
  DateTime end_time ;
  int selectedCountryId;
  var _formKey = new GlobalKey<FormState>();
  var _autoValidate = false;

  @override
  void initState() {
    storeName =TextEditingController();
    city=TextEditingController();
    postCode==TextEditingController();
    contactNo=TextEditingController();
    storeAddress=TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
        appBar:   AppBar(
          title: Text("Add Stores",
            style: TextStyle(
                color: yellowColor, fontSize: 25, fontWeight: FontWeight.bold
            ),
          ),
          iconTheme: IconThemeData(
              color: yellowColor
          ),
          centerTitle: true,
          backgroundColor:  BackgroundColor,
        ),
        body:
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: new Container(
              //decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: storeName,
                            style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            obscureText: false,
                            validator: (String value) =>
                            value.isEmpty ? "This field is Required" : null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor, width: 1.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                              ),
                              labelText: "Restaurant Name",
                              labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: city,
                            style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            obscureText: false,
                            validator: (String value) =>
                            value.isEmpty ? "This field is Required" : null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor, width: 1.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                              ),
                              labelText: "City",
                              labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: BackgroundColor,
                                //border: Border.all(color: yellowColor, width: 2),
                                borderRadius: BorderRadius.circular(9)
                              ),
                              child: ListTile(
                                title: TextFormField(
                                  controller: storeAddress,
                                  style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                                  obscureText: false,maxLines: 2,
                                  validator: (String value) =>
                                  value.isEmpty ? "This field is Required" : null,
                                  decoration: InputDecoration(
                                    // suffixIcon: Icon(Icons.add_location,color: Colors.amberAccent,),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: yellowColor, width: 1.0)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                                    ),
                                    labelText: 'Store Address',
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
                                      storeAddress.text = address.address;
                                      // latitude = address.latitude;
                                      // });
                                    },
                                    child: Icon(Icons.add_location,color: yellowColor, size: 30,)),
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: postCode,
                            style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            obscureText: false,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor, width: 1.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                              ),
                              labelText: "PostCode",
                              labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: contactNo,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold),
                            obscureText: false,
                            validator: (String value) =>
                            value.isEmpty ? "This field is Required" : null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: yellowColor, width: 1.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                              ),
                              labelText: "Contact Number",
                              labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),

                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(9),
                        //       //border: Border.all(color: yellowColor, width: 2)
                        //     ),
                        //     width: MediaQuery.of(context).size.width*0.98,
                        //     padding: EdgeInsets.all(14),
                        //     child: DropdownButtonFormField<Country>(
                        //       decoration: InputDecoration(
                        //         labelText: "Cuisine",
                        //         alignLabelWithHint: true,
                        //         labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: yellowColor),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(color:
                        //           yellowColor),
                        //         ),
                        //         focusedBorder:  OutlineInputBorder(
                        //           borderSide: BorderSide(color:
                        //           yellowColor),
                        //         ),
                        //       ),
                        //       validator: (value) => value == null
                        //           ? 'Please select One' : null,
                        //
                        //       // hint:  Text(translate('add_to_cart_screen.select_hint')),
                        //       value: selectedCountry,
                        //       onChanged: (Value) {
                        //         setState(() {
                        //           selectedCountry = Value;
                        //           print(selectedCountry.currencies[0].symbol);
                        //           selectedCountryId = countries.indexOf(selectedCountry);
                        //         });
                        //       },
                        //       items: countries.map((Country user) {
                        //         return  DropdownMenuItem<Country>(
                        //           value: user,
                        //           child: Row(
                        //             children: <Widget>[
                        //               //SizedBox(width: MediaQuery.of(context).size.width*0.6,),
                        //               Text(
                        //                 user.name,
                        //                 style:  TextStyle(color: yellowColor,fontSize: 13),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              //border: Border.all(color: yellowColor, width: 2)
                            ),
                            width: MediaQuery.of(context).size.width*0.98,
                            padding: EdgeInsets.all(14),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Cuisine",
                                alignLabelWithHint: true,
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
                              validator: (value) => value == null
                                  ? 'Please select One' : null,

                              // hint:  Text(translate('add_to_cart_screen.select_hint')),
                              value: selectedCuisine,
                              onChanged: (Value) {
                                setState(() {
                                  selectedCuisine = Value;
                                  // print(selectedCountry.currencies[0].symbol);
                                  // selectedCountryId = countries.indexOf(selectedCountry);
                                });
                              },
                              items: countries.map((user) {
                                return  DropdownMenuItem<String>(
                                  value: user,
                                  child: Text(user,
                                    style:  TextStyle(color: yellowColor,fontSize: 13),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              //border: Border.all(color: yellowColor, width: 2)
                            ),
                            width: MediaQuery.of(context).size.width*0.98,
                            padding: EdgeInsets.all(14),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Restaurant Currency",
                                alignLabelWithHint: true,
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
                              validator: (value) => value == null
                                  ? 'Please select One' : null,

                              // hint:  Text(translate('add_to_cart_screen.select_hint')),
                              value: selectedCurrency,
                              onChanged: (Value) {
                                setState(() {
                                  selectedCurrency = Value;
                                });
                              },
                              items: currencies.map((user) {
                                return  DropdownMenuItem<String>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        user,
                                        style:  TextStyle(color: yellowColor,fontSize: 18,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: yellowColor, width: 2)
                            ),
                            width: MediaQuery.of(context).size.width*0.98,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                // [Monday] checkbox
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Delivery",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                    Checkbox(

                                      value: deliveryVal,
                                      onChanged: (bool value) {
                                        setState(() {
                                          deliveryVal = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                // [Tuesday] checkbox
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Take Away",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                    Checkbox(
                                      value: pickUpVal,
                                      onChanged: (bool value) {
                                        setState(() {
                                          pickUpVal = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                // [Wednesday] checkbox
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Dine",style: TextStyle(color: yellowColor,fontSize: 15, fontWeight: FontWeight.bold),),
                                    Checkbox(
                                      value: dineInVal,
                                      onChanged: (bool value) {
                                        setState(() {
                                          dineInVal = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(9),
                              //border: Border.all(color: yellowColor, width: 2)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderDateTimePicker(
                                attribute: "Start Time",
                                style: Theme.of(context).textTheme.body1,
                                inputType: InputType.time,

                                //alwaysUse24HourFormat: true,
                                validators: [FormBuilderValidators.required()],
                                format: DateFormat("HH:mm:ss"),
                                decoration: InputDecoration(labelText: "Select start time",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color: yellowColor, width: 2.0)
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    this.start_time=value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(9),
                                //border: Border.all(color: yellowColor, width: 2)

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FormBuilderDateTimePicker(
                                attribute: "End Time",
                                style: Theme.of(context).textTheme.body1,
                                inputType: InputType.time,
                               // alwaysUse24HourFormat: true,
                                validators: [FormBuilderValidators.required()],
                                format: DateFormat("HH:mm:ss"),
                                decoration: InputDecoration(labelText: "Select end time",labelStyle: TextStyle(color:yellowColor, fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9.0),
                                      borderSide: BorderSide(color:yellowColor, width: 2.0)
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    this.end_time=value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      _validateInputs();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("SAVE",style: TextStyle(color: BackgroundColor,fontSize: 20, fontWeight: FontWeight.bold)))
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      Utils.showError(context, "Please fix the Errors");
    } else {
      form.save();
      dynamic storeData={

        "Name":storeName.text,
        "CellNo":contactNo.text,
        "City":city.text,
        "Address":storeAddress.text,
        "Longitude":address.longitude,
        "Latitude":address.latitude,
        "RestaurantId":int.parse(widget.restaurantId.toString()),
        "OpenTime": start_time.toString().substring(11,19),//_timeRange.start.format(context),
        "CloseTime": end_time.toString().substring(11,19),//_timeRange.end.format(context),
        "FoodType": selectedCuisine,//countries[selectedCountryId].name.toString(),
        "CurrencyCode": selectedCurrency,//countries[selectedCountryId].currencies[0].symbol.toString(),
        "Delivery": deliveryVal,
        "DineIn": pickUpVal,
        "TakeAway": dineInVal,
        "MerchantId": "vw012t1b90",
        "Password": "MC15422",
        "IntegritySalt": "3c97sx34c9"
      };
      print(storeData);
      networksOperation.addStore(context, token, storeData).then((value) {
        if(value!=null){
          Utils.showSuccess(context, "Successfully Added");
          Navigator.pop(context);
        }else{
          Utils.showError(context, "Not Added");
        }
      });

    }
  }

}
