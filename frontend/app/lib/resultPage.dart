import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<DateInfo> entries = <DateInfo>[
    DateInfo("Mandag", "08-17", 60, const Icon(Icons.check_circle_outline, color: Colors.green,), [
      RelativeHumidity(8, 40, Icons.cloud),
      RelativeHumidity(10, 45, Icons.wb_sunny),
      RelativeHumidity(12, 80, Icons.water_drop),
      RelativeHumidity(14, 75, Icons.water_drop),
      RelativeHumidity(16, 55, Icons.cloud),
      RelativeHumidity(18, 45, Icons.wb_sunny),
      RelativeHumidity(20, 40, Icons.wb_sunny),
      RelativeHumidity(22, 50, Icons.wb_sunny),
    ]),
    DateInfo("Tirsdag", "11-13", 60, const Icon(Icons.error_outline, color: Colors.red,), [
      RelativeHumidity(8, 40, Icons.cloud),
      RelativeHumidity(10, 45, Icons.wb_sunny),
      RelativeHumidity(12, 80, Icons.water_drop),
      RelativeHumidity(14, 75, Icons.water_drop),
      RelativeHumidity(16, 55, Icons.cloud),
      RelativeHumidity(18, 45, Icons.wb_sunny),
      RelativeHumidity(20, 40, Icons.wb_sunny),
      RelativeHumidity(22, 50, Icons.wb_sunny),
    ]),
  ];
  final List<bool> expansionStuff = [false, false];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Paint-O-Meter"), centerTitle: true, actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search))],),
        body: Column(
          children: [
            productWidget("Flügger Facade Beton - Betonmaling", "https://assets.flugger.dk/static/ir/789878/24408_Facade%20Beton_07_0,75L_FACADE%20BET%20(1).png?width=500&quality=80&format=webp&rmode=Pad", 1, 60),
            Card(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return dateWidget(entries[index], expansionStuff, index, (bool expanded) {
                    setState(() => expansionStuff[index] = expanded);
                  }, context);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          ],
        ),
    );
  }
}

Widget productWidgetNy(String productName, String imgUrl, int dryTime, int relativeHumidity, String webUrl  ) {
  final Uri _url = Uri.parse('https://flutter.dev');

  Future<void> _launchUrl() async {
    debugPrint("GestureDetector tapped!");

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  return
    InkWell(
      onTap: _launchUrl,
      child: Card(
        child: ListTile(
          title: Text(productName),
          subtitle: Text("Tørretid: $dryTime\n Fugt < $relativeHumidity"),
          trailing: Image.network(imgUrl),
        ),
      ),
    );


}

Widget productWidget(String productName, String imgUrl, int dryTime, int relativeHumidity) {
  final Uri _url = Uri.parse('https://flutter.dev');

  Future<void> _launchUrl() async {
    debugPrint("GestureDetector tapped!");

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  return
    InkWell(
      onTap: _launchUrl,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Column(
                    children: [Text("Tørretid: ${dryTime}T", style: const TextStyle(fontSize: 16),), Text("RF værdi: $relativeHumidity", style: const TextStyle(fontSize: 16),)],
                  ),
                  Spacer(),
                  Image.network(imgUrl, height: 150,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
}

Widget dateWidget(DateInfo date, List<bool> expansionStuff, int index, onExpansionChanged, context) {
  final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

  return Theme(
    data: theme,
    child: ExpansionTile(
      title: Text(date.weekDay),
      subtitle: Text("Det anbefalede tidsrum at male i er ${date.approvedTime}"),
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          date.reasoningIcon, // icon-1
          Icon(expansionStuff[index]
              ? Icons.arrow_drop_up
              : Icons.arrow_drop_down), // icon-2
        ],
      ),
      children: [humidityWidget(date),],
      onExpansionChanged: onExpansionChanged
    ),
  );
}

Widget humidityWidget(DateInfo data) {
  return SizedBox(
    height: 120,
    child: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: data.humidityList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return SizedBox(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  height: 20,
                  child: Center(
                    child: Text("Luftfugtighed", style: TextStyle(
                        fontSize: 12)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 20,
                  child: Center(
                    child: Text("Tidspunkt",
                      style: TextStyle(fontSize: 12),),
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: 65,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${data.humidityList[index].humidity}%", style: TextStyle(
                    color: (data.humidityList[index].humidity <=
                        data.relativeHumidity) ? Colors.green : Colors.red,
                    fontSize: 18)),
                Text("${data.humidityList[index].time}:00",
                  style: const TextStyle(fontSize: 18),),
                Icon(data.humidityList[index-1].iconData)
              ],
            ),
          );
        }
      },
      separatorBuilder: (context, index) {
        return const VerticalDivider();
      },
    ),
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
  final IconData iconData;

  RelativeHumidity(this.time, this.humidity, this.iconData);
}


