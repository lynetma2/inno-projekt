import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:app/exampleData.dart';
import 'main.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<PaintProduct> futurePaintProduct;
  late Future<List<DateInfo>> futureDateInfos;

  Future<PaintProduct> fetchPaint(String id) async {
    //TODO update the URL
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //TODO change this to the actual data
      return PaintProduct.fromTestData();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load product');
    }
  }
  
  Future<List<DateInfo>> fetchDates(String id, double latitude, double longitude) async {
    //TODO update the URL
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/2'));
    
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(JUDGEMENT); //TODO update this
      debugPrint("JSON is not parsed yet");
      for (int i = 0; i < jsonResponse.length; i++) {
        List<DataPoint> datapoints = (jsonResponse[i]['dataPoints'] as List).map((e) => DataPoint.fromJson(e)).toList();
        debugPrint(datapoints.toString());
        debugPrint("Time: " + jsonResponse[i]['time'].toString());
        debugPrint("judgement: " + jsonResponse[i]['judgement'].toString());
        debugPrint(jsonResponse[i].runtimeType.toString());
        debugPrint(DateInfo.fromTestData().toString());
      }
      List<DateInfo> dates = [];
      //List<DateInfo> dates = jsonResponse.map((e) => DateInfo.fromJson(e)).toList();
      debugPrint("JSON is successfully parsed");

      return dates;
    } else {
      throw Exception('Failed to load dateinfo');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePaintProduct = fetchPaint(widget.id);
    //TODO update the coordinates
    futureDateInfos = fetchDates(widget.id, 10.402931, 55.372364);
  }

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
            FutureBuilder(
                future: futurePaintProduct,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _productWidget(snapshot.data!);
                  } else if (snapshot.hasError) {
                    return const Text("An error occured");
                  }

                  return const CircularProgressIndicator();
                }),
            FutureBuilder(
              future: futureDateInfos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //Build the normal widget
                  return Card(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return dateWidget(snapshot.data![index], index,
                                (bool expanded) {
                              setState(() => snapshot.data![index].expanded = expanded);
                            }, context);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text("An error occured");
                }

                return const CircularProgressIndicator();
              }
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

Widget dateWidget(DateInfo date, int index,
    onExpansionChanged, context) {
  final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

  return Theme(
    data: theme,
    child: ExpansionTile(
        title: Text(date.time),
        subtitle: //TODO vent på map fra kasper om tildelingen
            const Text("Fint at male nu"),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            const Icon(Icons.check_circle_outline, color: Colors.green,), // icon-1 TODO do something here again with the map
            Icon(date.expanded
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down), // icon-2
          ],
        ),
        onExpansionChanged: onExpansionChanged,
        children: [
          humidityWidget(date),
        ]),
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
      itemCount: data.datapoints.length +1 ,
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
                Text("${(data.datapoints[index -1].humidity * 100).round()}%",
                    style: TextStyle(
                        color:
                            _humidityColor(data.datapoints[index -1].humidity),
                        fontSize: 18)),
                Text(
                  "${data.datapoints[index -1].temp} \u2103",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "${data.datapoints[index -1].time}:00",
                  style: const TextStyle(fontSize: 18),
                ),
                //TODO do something about the map here again
                const Icon(Icons.sunny)
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
  String time;
  int judgement;
  List<DataPoint> datapoints;
  bool expanded = false;

  DateInfo(this.time, this.judgement, this.datapoints);

  DateInfo.fromJson(Map<String, dynamic> json)
    : time = json['time'] as String,
      judgement = json['judgement'].toString() as int,
      datapoints = (json['dataPoints'] as List).map((e) => DataPoint.fromJson(e)).toList();

  factory DateInfo.fromTestData() {
    Map<String, dynamic> dateInfoMap = jsonDecode('{"judgement":0,"dataPoints":[{"rf":0.845,"temperature":26.5,"icon":2,"time":"2022-12-14T02:00:00Z"},{"rf":0.838,"temperature":26.6,"icon":2,"time":"2022-12-14T03:00:00Z"},{"rf":0.8270000000000001,"temperature":26.8,"icon":2,"time":"2022-12-14T04:00:00Z"},{"rf":0.8190000000000001,"temperature":26.9,"icon":2,"time":"2022-12-14T05:00:00Z"},{"rf":0.813,"temperature":27,"icon":2,"time":"2022-12-14T06:00:00Z"},{"rf":0.8170000000000001,"temperature":27,"icon":2,"time":"2022-12-14T07:00:00Z"},{"rf":0.8059999999999999,"temperature":27.2,"icon":2,"time":"2022-12-14T08:00:00Z"},{"rf":0.802,"temperature":27.3,"icon":2,"time":"2022-12-14T09:00:00Z"},{"rf":0.792,"temperature":27.5,"icon":2,"time":"2022-12-14T10:00:00Z"},{"rf":0.7829999999999999,"temperature":27.6,"icon":2,"time":"2022-12-14T11:00:00Z"},{"rf":0.764,"temperature":27.7,"icon":0,"time":"2022-12-14T12:00:00Z"},{"rf":0.746,"temperature":27.9,"icon":2,"time":"2022-12-14T13:00:00Z"},{"rf":0.745,"temperature":28,"icon":0,"time":"2022-12-14T14:00:00Z"},{"rf":0.733,"temperature":27.9,"icon":0,"time":"2022-12-14T15:00:00Z"},{"rf":0.723,"temperature":27.8,"icon":2,"time":"2022-12-14T16:00:00Z"},{"rf":0.738,"temperature":27.8,"icon":2,"time":"2022-12-14T17:00:00Z"},{"rf":0.741,"temperature":27.8,"icon":2,"time":"2022-12-14T18:00:00Z"},{"rf":0.7559999999999999,"temperature":27.7,"icon":2,"time":"2022-12-14T19:00:00Z"},{"rf":0.759,"temperature":27.6,"icon":2,"time":"2022-12-14T20:00:00Z"},{"rf":0.754,"temperature":27.6,"icon":2,"time":"2022-12-14T21:00:00Z"},{"rf":0.754,"temperature":27.7,"icon":2,"time":"2022-12-14T22:00:00Z"},{"rf":0.7490000000000001,"temperature":27.8,"icon":2,"time":"2022-12-14T23:00:00Z"}],"time":"2022-12-14T02:00Z"}');
    return DateInfo.fromJson(dateInfoMap);
  }
}

class DataPoint {
  final String time;
  final double humidity;
  final double temp;
  final int icon;

  DataPoint(this.time, this.humidity, this.temp, this.icon);

  DataPoint.fromJson(Map<String, dynamic> json)
    : time = json['time'],
      humidity = json['rf'],
      temp = json['temperature'].toDouble(),
      icon = json['icon'];
}
