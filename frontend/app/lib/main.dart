import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/resultPage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:string_similarity/string_similarity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paint-O-Meter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Los Colorum'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool searching = false;

  Future<Map<String, String>> fetchPaintNames() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      //TODO make the parser

      //for now example data
      Map<String, String> testData = {
        'Flügger Indendørs Farveprøve': '6ff3cd36-16f5-4997-a683-15c8c9adf149',
        'Flügger 01 Wood Tex Classic - Grundingsolie' : 'b6e8e4a0-32ca-40e6-a917-dacdba4c8385',
        'Flügger Wood Oil - Vandig træolie' : '8db6918e-470d-47f6-bd8e-c7e86654c62c',
        'Flügger 07 Wood Tex Mat - Træbeskyttelse' : '9d02937f-998e-4073-bf9f-3677bff8ba8b',
        'Flügger Facade Beton - Betonmaling' : '976baf17-0418-44df-a3ef-5e2846e223c6',
      };
      return testData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void _findtext() async {
    setState(() {
      searching = true;
    });
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    debugPrint(image!.path);
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    debugPrint(recognizedText.text);
    //TODO check which product it should on next page
    Map<String, String> paintNames = await fetchPaintNames();
    var matches = recognizedText.text.toString().bestMatch(paintNames.keys.toList());
    debugPrint(matches.toString());
    //if (matches.bestMatch.rating! >= 0.2) {
      setState(() {
        searching = false;
      });
      //_switchPage(paintNames[matches.bestMatch.target]!);
        _switchPage("testID");
    //} else {
      //TODO create error and allow manual search
    //}
  }

  void _switchPage(String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResultPage(id: id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paint-O-Meter"),
        centerTitle: true,
      ),
      body: searching ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _findtext,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt),
                      Text("Søg"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            const Text("Historik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: [
                _productWidget(PaintProduct.fromTestData()),
                _productWidget(PaintProduct.fromTestData())
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _productWidget(PaintProduct paint) {
  return
    Card(
      child: ListTile(
        title: Text(paint.name),
        subtitle: Text("Støvtør: ${paint.surfacedry} time\nGenbehandlingstør: ${paint.recoatdry} timer\nGennemhærdet: ${(paint.curingtime / 24).round()} døgn\nTiderne er ca. ved 20\u2103 og RF: 60%"),
        trailing: Image.network(paint.imgurl),
      ),
    );
}

class PaintProduct {
  final String id;
  final int productid;
  final String name;
  final int surfacedry;
  final int recoatdry;
  final int curingtime;
  final String imgurl;
  final String url;

  PaintProduct(this.id, this.productid, this.name, this.surfacedry, this.recoatdry, this.curingtime, this.imgurl, this.url);

  PaintProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        productid = json['productid'],
        name = json['name'],
        surfacedry = json['surfacedry'],
        recoatdry = json['recoatdry'],
        curingtime = json['curingtime'],
        imgurl = json['imgurl'],
        url = json['url'];
  
  factory PaintProduct.fromTestData() {
    Map<String, dynamic> paintMap = jsonDecode('{ "surfacedry": 1, "imgurl": "https://assets.flugger.dk/static/ir/107720/32188_Colour%20Sample_01_0,38L_FARVEPR.png?width=500&quality=80&format=webp&rmode=Pad", "productid": 13218, "curingtime": 672, "name": "Flügger Indendørs Farveprøve", "recoatdry": 6, "id": "6ff3cd36-16f5-4997-a683-15c8c9adf149", "url": "https://www.flugger.dk/indendoers/loftmaling/farveproeve/p-FARVEPR/" }');
    return PaintProduct.fromJson(paintMap);
  }
}
