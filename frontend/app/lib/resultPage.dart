import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<DateInfo> entries = <DateInfo>[
    DateInfo("Mandag", "08-17", 60, const Icon(Icons.check_circle_outline, color: Colors.green,), [
      RelativeHumidity(8, 40),
      RelativeHumidity(10, 45),
      RelativeHumidity(12, 80),
      RelativeHumidity(14, 75),
      RelativeHumidity(16, 55),
      RelativeHumidity(18, 45),
      RelativeHumidity(20, 40),
      RelativeHumidity(22, 50),
    ]),
    DateInfo("Tirsdag", "11-13", 60, const Icon(Icons.error_outline, color: Colors.red,), [
      RelativeHumidity(8, 40),
      RelativeHumidity(10, 45),
      RelativeHumidity(12, 80),
      RelativeHumidity(14, 75),
      RelativeHumidity(16, 55),
      RelativeHumidity(18, 45),
      RelativeHumidity(20, 40),
      RelativeHumidity(22, 50),
    ]),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("App Navn"), centerTitle: true,),
        body: Column(
          children: [
            productWidget("Flügger Facade Beton - Betonmaling", "https://assets.flugger.dk/static/ir/789878/24408_Facade%20Beton_07_0,75L_FACADE%20BET%20(1).png?width=500&quality=80&format=webp&rmode=Pad", 1, 60),
            Card(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return dateWidget(entries[index]);
                },
              ),
            ),
            Card(
              child: Container(height: 80, child: humidityWidget(entries[0]))
            ),
          ],
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

Widget humidityWidget(DateInfo data) {
  return ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: data.humidityList.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      return SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${data.humidityList[index].humidity}%", style: TextStyle(color: (data.humidityList[index].humidity <= data.relativeHumidity) ? Colors.green : Colors.red, fontSize: 18)),
            Text("${data.humidityList[index].time}:00", style: const TextStyle(fontSize: 18),),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) {
      return const VerticalDivider();
    },
  );
}

class DateInfo {
  String weekDay;
  String approvedTime;
  int relativeHumidity;
  Icon reasoningIcon;
  List<RelativeHumidity> humidityList;

  DateInfo(this.weekDay, this.approvedTime, this.relativeHumidity, this.reasoningIcon, this.humidityList);
}

class RelativeHumidity {
  final int time;
  final int humidity;

  RelativeHumidity(this.time, this.humidity);
}


