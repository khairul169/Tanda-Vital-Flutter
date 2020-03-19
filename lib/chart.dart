import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartValue {
  final int key;
  final int value;

  ChartValue(this.key, this.value);
}

class ChartSeries {
  final String id;
  final List<ChartValue> values;
  final Color color;

  ChartSeries({this.id, @required this.values, this.color = Colors.blue});
}

class TimeChart extends StatelessWidget {
  final String title;
  final double height;
  final List<ChartSeries> series;
  final String leftText;
  final int timeSpan;

  TimeChart({
    this.title,
    this.height = 250,
    @required this.series,
    this.leftText,
    this.timeSpan = 0,
  });

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartValue, int>> seriesList = series.map((ChartSeries series) {
      return charts.Series<ChartValue, int>(
        id: series.id,
        data: series.values,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(series.color),
        domainFn: (ChartValue item, _) => item.key,
        measureFn: (ChartValue item, _) => item.value,
      );
    }).toList();

    List<charts.ChartBehavior> behaviors = [
      charts.ChartTitle(
        title,
        behaviorPosition: charts.BehaviorPosition.top,
        titleOutsideJustification: charts.OutsideJustification.start,
        innerPadding: 32,
        titleStyleSpec: charts.TextStyleSpec(fontSize: 16)
      ),
      charts.ChartTitle(
        "Jam",
        behaviorPosition: charts.BehaviorPosition.bottom,
        titleStyleSpec: charts.TextStyleSpec(fontSize: 12)
      ),
      charts.ChartTitle(
        leftText,
        behaviorPosition: charts.BehaviorPosition.start,
        titleStyleSpec: charts.TextStyleSpec(fontSize: 12)
      ),
      charts.LinePointHighlighter(
        showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
        showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.none
      )
    ];

    if (series.length > 1) {
      behaviors.add(charts.SeriesLegend(position: charts.BehaviorPosition.bottom));
    }

    return SizedBox(
      height: height,
      child: charts.LineChart(
        seriesList,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
        domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 9),
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num value) {
            int time = value.toInt() + timeSpan;
            return (time % 2 == 0)
            ? time.toString().padLeft(2, '0')
            : "";
          })
        ),
        behaviors: behaviors,
        animate: true,
      )
    );
  }
}
