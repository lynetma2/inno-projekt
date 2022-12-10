import 'package:app/resultPage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

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

  void _findtext() async {
    //final ImagePicker _picker = ImagePicker();
    //final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    //debugPrint(image!.path);
    //final inputImage = InputImage.fromFilePath(image.path);
    //final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    //final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    //debugPrint(recognizedText.text);
    _switchPage();
  }

  void _switchPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ResultPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paint-O-Meter"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                productWidget("Flügger Facade Beton - Betonmaling", "https://assets.flugger.dk/static/ir/789878/24408_Facade%20Beton_07_0,75L_FACADE%20BET%20(1).png?width=500&quality=80&format=webp&rmode=Pad", 1, 60),
                productWidget("Flügger Facade Beton - Betonmaling", "https://assets.flugger.dk/static/ir/789878/24408_Facade%20Beton_07_0,75L_FACADE%20BET%20(1).png?width=500&quality=80&format=webp&rmode=Pad", 1, 60),
                productWidget("Flügger Facade Beton - Betonmaling", "https://assets.flugger.dk/static/ir/789878/24408_Facade%20Beton_07_0,75L_FACADE%20BET%20(1).png?width=500&quality=80&format=webp&rmode=Pad", 1, 60),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget productWidget(String productName, String imgUrl, int dryTime, int relativeHumidity) {
  return
    Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text("Tørretid: $dryTime\n Fugt < $relativeHumidity"),
        trailing: Image.network(imgUrl),
      ),
    );
}
