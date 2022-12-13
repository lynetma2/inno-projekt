import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final List<DateInfo> entries = <DateInfo>[
    DateInfo(
        "Mandag",
        "08-17",
        60,
        const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
    DateInfo(
        "Tirsdag",
        "11-13",
        60,
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
    DateInfo(
        "Onsdag",
        "11-13",
        60,
        const Icon(
          Icons.question_mark_outlined,
          color: Colors.orange,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
    DateInfo(
        "Torsdag",
        "11-13",
        60,
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
    DateInfo(
        "Fredag",
        "11-13",
        60,
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
    DateInfo(
        "Lørdag",
        "11-13",
        60,
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
    DateInfo(
        "Søndag",
        "11-13",
        60,
        const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        [
          RelativeHumidity(8, 0.40, 22.3, Icons.cloud),
          RelativeHumidity(10, 0.45, 22.3, Icons.wb_sunny),
          RelativeHumidity(12, 0.80, 21.3, Icons.water_drop),
          RelativeHumidity(14, 0.75, 24.3, Icons.water_drop),
          RelativeHumidity(16, 0.55, 25.2, Icons.cloud),
          RelativeHumidity(18, 0.45, 12.3, Icons.wb_sunny),
          RelativeHumidity(20, 0.40, 14.3, Icons.wb_sunny),
          RelativeHumidity(22, 0.50, 15.3, Icons.wb_sunny),
        ]),
  ];
  final List<bool> expansionStuff = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paint-O-Meter"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _productWidget(PaintProduct.fromTestData()),
            Card(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return dateWidget(entries[index], expansionStuff, index,
                      (bool expanded) {
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
      ),
    );
  }
}

Widget _productWidget(PaintProduct paint) {
  final Uri _url = Uri.parse(paint.url);

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  return InkWell(
    onTap: _launchUrl,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              paint.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Støvtør: ${paint.surfacedry} time(r)",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Genbehandlingstør: ${paint.recoatdry} time(r)",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Gennemhærdet: ${(paint.curingtime / 24).round()} døgn",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Text(
                      "Tiderne er ca. ved 20\u2103 og RF: 60%\nAlt ansvar fralægges.",
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                Image.network(
                  paint.imgurl,
                  height: 120,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget dateWidget(DateInfo date, List<bool> expansionStuff, int index,
    onExpansionChanged, context) {
  final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

  return Theme(
    data: theme,
    child: ExpansionTile(
        title: Text(date.weekDay),
        subtitle:
            Text("Det anbefalede tidsrum at male i er ${date.approvedTime}"),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            date.reasoningIcon, // icon-1
            Icon(expansionStuff[index]
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down), // icon-2
          ],
        ),
        children: [
          humidityWidget(date),
        ],
        onExpansionChanged: onExpansionChanged),
  );
}

Widget humidityWidget(DateInfo data) {
  Color _humidityColor(double humidity) {
    if (humidity <= 0.4 || humidity >= 0.8) {
      return Colors.red;
    } else if (humidity < 0.55 || humidity > 0.65) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

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
                    child:
                        Text("Luftfugtighed", style: TextStyle(fontSize: 12)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 20,
                  child: Center(
                    child: Text(
                      "Temperatur",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 20,
                  child: Center(
                    child: Text(
                      "Tidspunkt",
                      style: TextStyle(fontSize: 12),
                    ),
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
                Text("${(data.humidityList[index].humidity * 100).round()}%",
                    style: TextStyle(
                        color:
                            _humidityColor(data.humidityList[index].humidity),
                        fontSize: 18)),
                Text(
                  "${data.humidityList[index].temp} \u2103",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "${data.humidityList[index].time}:00",
                  style: const TextStyle(fontSize: 18),
                ),
                Icon(data.humidityList[index - 1].iconData)
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
  double minTemp;
  Icon reasoningIcon;
  List<RelativeHumidity> humidityList;

  DateInfo(this.weekDay, this.approvedTime, this.minTemp, this.reasoningIcon,
      this.humidityList);
}

class RelativeHumidity {
  final int time;
  final double humidity;
  final double temp;
  final IconData iconData;

  RelativeHumidity(this.time, this.humidity, this.temp, this.iconData);
}
