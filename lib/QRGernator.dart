import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';


class GenerateScreen extends StatefulWidget {
  String _dataString;

  GenerateScreen(this._dataString);

  @override
  State<StatefulWidget> createState() => GenerateScreenState(_dataString);
}

class GenerateScreenState extends State<GenerateScreen> {

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GenerateScreenState(this._dataString);

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColor,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text('Generate QR Code', style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: yellowColor,
        ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share, color: PrimaryColor,),
          onPressed: ()async{
            RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
            var image = await boundary.toImage();
            ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
            Uint8List pngBytes = byteData.buffer.asUint8List();
            Utils.shareImage(context, pngBytes);
          },
          ),
          IconButton(
            icon: Icon(Icons.print, color: PrimaryColor,),
            onPressed: () async{
             // Navigator.push(context,MaterialPageRoute(builder: (context)=>PDFLaout("Hello")));
              final doc = pw.Document();
              RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
              var image = await boundary.toImage();
              ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
              Uint8List pngBytes = byteData.buffer.asUint8List();
              final PdfImage img = await pdfImageFromImageProvider(pdf: doc.document, image: MemoryImage(pngBytes));
              doc.addPage(pw.Page(
                  build: (pw.Context context) {
                    return pw.Column(
                        children: [
                          pw.Center(
                              child: pw.Text(widget._dataString.substring(0,5),style: pw.TextStyle(fontSize: 30,fontWeight: pw.FontWeight.bold))
                          ),
                          pw.Padding(padding: pw.EdgeInsets.all(8.0)),
                          pw.Center(
                              child: pw.Image(img,width: 300,height:300)
                          ),
                          pw.Padding(padding: pw.EdgeInsets.all(8.0)),
                          pw.Center(
                              child: pw.Text("this QRCode is Generated By ExaBistro",style: pw.TextStyle(fontSize: 27))
                          ),
                        ]
                    );
                  })); // Pa
              await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => doc.save());
            },
          )
        ],
      ),
      body: _contentWidget(),
    );
  }


  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[

          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                  // onError: (ex) {
                  //   print("[QR] ERROR - $ex");
                  //   setState((){
                  //     _inputErrorText = "Error! Maybe your input value is too long?";
                  //   });
                  // },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}