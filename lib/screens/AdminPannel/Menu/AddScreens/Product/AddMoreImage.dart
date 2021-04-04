import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddProductDetails.dart';


class AddMoreImages extends StatefulWidget {
  var storeId,categoryId,subCategoryId;
  Products productDetails;

  AddMoreImages(this.storeId,this.categoryId,this.subCategoryId,this.productDetails);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add_CategoryState();
  }
}

class _add_CategoryState extends State<AddMoreImages> {
  String token;
  File _image,_image2,_image3;
  var picked_image,picked_image2,picked_image3;
  var responseJson;
  TextEditingController name,storeId,description;
  var storeName,storeIdIndex;
  List storeNameList=[],storeList=[];

//  _add_CategoryState(this.token);

  @override
  void initState(){
    this.name=TextEditingController();
    this.storeId=TextEditingController();
    this.description=TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
        name.text = widget.productDetails.name;
        description.text = widget.productDetails.description;
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor,
        centerTitle: true,
        title: Text("Add More Images", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        height: 100,
                        width: 80,
                        child: _image == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image),
                      ),
                      MaterialButton(
                        color: yellowColor,
                        onPressed: (){
                          Utils.getImage().then((image_file){
                            if(image_file!=null){
                              image_file.readAsBytes().then((image){
                                if(image!=null){
                                  setState(() {
                                    //this.picked_image=image;
                                    _image = image_file;
                                    this.picked_image = base64Encode(image);
                                  });
                                }
                              });
                            }else{

                            }
                          });
                        },
                        child: Text("Select Image",style: TextStyle(color: BackgroundColor),),
                      ),
                    ],
                  ),
                ),

                // SizedBox(height: 5),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Container(
                //         margin: EdgeInsets.all(16),
                //         height: 100,
                //         width: 80,
                //         child: _image2 == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image2),
                //       ),
                //       MaterialButton(
                //         color: yellowColor,
                //         onPressed: (){
                //           Utils.getImage().then((image_file){
                //             if(image_file!=null){
                //               image_file.readAsBytes().then((image){
                //                 if(image!=null){
                //                   setState(() {
                //                     //this.picked_image=image;
                //                     _image2 = image_file;
                //                     this.picked_image2 = base64Encode(image);
                //                   });
                //                 }
                //               });
                //             }else{
                //
                //             }
                //           });
                //         },
                //         child: Text("Select Image",style: TextStyle(color: BackgroundColor),),
                //       ),
                //     ],
                //   ),
                // ),
                //
                // SizedBox(height: 5),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Container(
                //         margin: EdgeInsets.all(16),
                //         height: 100,
                //         width: 80,
                //         child: _image3 == null ? Text('No image selected.', style: TextStyle(color: PrimaryColor),) : Image.file(_image3),
                //       ),
                //       MaterialButton(
                //         color: yellowColor,
                //         onPressed: (){
                //           Utils.getImage().then((image_file){
                //             if(image_file!=null){
                //               image_file.readAsBytes().then((image){
                //                 if(image!=null){
                //                   setState(() {
                //                     //this.picked_image=image;
                //                     _image3 = image_file;
                //                     this.picked_image3 = base64Encode(image);
                //                   });
                //                 }
                //               });
                //             }else{
                //
                //             }
                //           });
                //         },
                //         child: Text("Select Image",style: TextStyle(color: BackgroundColor),),
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(height: 5),

                InkWell(
                  onTap: (){
                    if(name.text==null||name.text.isEmpty){
                      Utils.showError(context, "Name field is empty");

                    }
                    else {



                      Utils.check_connectivity().then((result){
                        if(result){
                          dynamic product ={
                            "id":widget.productDetails.id,
                            "storeid":widget.storeId.toString(),
                            "categoryId":widget.categoryId.toString(),
                            "subCategoryId":widget.subCategoryId.toString(),
                            "ProductPictures":[
                              {
                                "Name": picked_image
                              },
                            ],
                          //  "image": picked_image

                          };
                          print(product);
                          networksOperation.updateProduct(context, token, product).then((response){
                            if(response){
                              Utils.showSuccess(context, "Successfully Update");
                            }else{
                              Utils.showError(context, "Please Try Agian");
                            }
                          });
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(token,widget.categoryId,
                          //   widget.subCategoryId,
                          //   widget.productDetails.id,
                          //   name.text,
                          //   description.text,
                          //   //storeList[storeIdIndex]['id'],
                          //
                          //   picked_image,
                          //   widget.storeId,
                          // )));

                        }else{
                          Utils.showError(context, "Check your Internet Connection");
                        }
                      });

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
                      height: MediaQuery.of(context).size.height  * 0.06,

                      child: Center(
                        child: Text("UPDATE",style: TextStyle(color: BackgroundColor,fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
