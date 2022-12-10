import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<DateInfo> entries = <DateInfo>[
    DateInfo("Mandag", "08-17", 60, const Icon(Icons.check_circle_outline, color: Colors.green,)),
    DateInfo("Tirsdag", "11-13", 60, const Icon(Icons.error_outline, color: Colors.red,)),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("App Navn"), centerTitle: true,),
        body: Column(
          children: [
            productWidgetNy("Flügger Facade Beton - Betonmaling", "https://assets.flugger.dk/static/ir/789878/24408_Facade%20Beton_07_0,75L_FACADE%20BET%20(1).png?width=500&quality=80&format=webp&rmode=Pad", 1, 60),
            Card(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return dateWidget(entries[index]);
                },
              ),
            )
          ],
        ),
    );
  }
}

Widget productWidget(String productName, String imgUrl, int dryTime, int relativeHumidity) {
  return
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(productName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Image.network(imgUrl, height: 230,),
            Row(
              children: [
                Text("Tørretid: $dryTime", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Spacer(),
                Text("Fugt < $relativeHumidity", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
              ],
            )
          ],
        ),
      ),
  );
}

Widget productWidgetNy(String productName, String imgUrl, int dryTime, int relativeHumidity) {
  return
    Card(
      child: ListTile(
        title: Text(productName),
        subtitle: Text("Tørretid: $dryTime\n Fugt < $relativeHumidity"),
        trailing: Image.network(imgUrl),
      ),
    );
}

Widget dateWidget(DateInfo date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(date.weekDay, style: const TextStyle(fontSize: 18),),
              Spacer(),
              Text(date.approvedTime, style: const TextStyle(fontSize: 18),),
            ],
          ),
          Row(
            children: [
              Text("fugt < ${date.relativeHumidity}", style: const TextStyle(fontSize: 18),),
              Spacer(),
              date.reasoningIcon,
            ],
          )
        ],
      ),
  );
}

class DateInfo {
  String weekDay;
  String approvedTime;
  int relativeHumidity;
  Icon reasoningIcon;

  DateInfo(this.weekDay, this.approvedTime, this.relativeHumidity, this.reasoningIcon);
}


