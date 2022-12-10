import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TestChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  const TestChart(this.seriesList, {required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory TestChart.withSampleData() {
    return TestChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(seriesList,
        animate: animate,
        domainAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
          viewport: charts.NumericExtents(8, 22)
        ),
        primaryMeasureAxis: const charts.NumericAxisSpec(
            tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
            viewport: charts.NumericExtents(20, 90)
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customArea',
              includeArea: true,
              stacked: true),
        ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<RelativeHumidity, int>> _createSampleData() {
    final myFakeDesktopData = [
      RelativeHumidity(8, 40),
      RelativeHumidity(10, 45),
      RelativeHumidity(12, 80),
      RelativeHumidity(14, 75),
      RelativeHumidity(16, 55),
      RelativeHumidity(18, 45),
      RelativeHumidity(20, 40),
      RelativeHumidity(22, 50),
    ];

    var myFakeTabletData = [
      RelativeHumidity(8, 60),
      RelativeHumidity(10, 60),
      RelativeHumidity(12, 60),
      RelativeHumidity(14, 60),
      RelativeHumidity(16, 60),
      RelativeHumidity(18, 60),
      RelativeHumidity(20, 60),
      RelativeHumidity(22, 60),
    ];

    return [
      charts.Series<RelativeHumidity, int>(
        id: 'Desktop',
        colorFn: (RelativeHumidity sales, _) {
          if(sales.humidity < 60){
            return charts.MaterialPalette.green.shadeDefault;
          } else {
            return charts.MaterialPalette.red.shadeDefault;
          }
        },
        domainFn: (RelativeHumidity sales, _) => sales.time,
        measureFn: (RelativeHumidity sales, _) => sales.humidity,
        data: myFakeDesktopData,
      ),
        // Configure our custom bar target renderer for this series.
        //..setAttribute(charts.rendererIdKey, 'customArea'),
      charts.Series<RelativeHumidity, int>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (RelativeHumidity sales, _) => sales.time,
        measureFn: (RelativeHumidity sales, _) => sales.humidity,
        data: myFakeTabletData,
      ),
    ];
  }
}

/// Sample linear data type.
class RelativeHumidity {
  final int time;
  final int humidity;

  RelativeHumidity(this.time, this.humidity);
}
