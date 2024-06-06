import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/config.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.chartLines,
    this.leftTitleRenderer,
    this.bottomTitleRenderer,
    this.leftTitles,
    this.bottomTitles,
    this.maxX = 400,
    this.maxY = 100,
    this.minX = 0,
    this.minY = 60,
    this.height = 200,
    this.width,
    this.horizontalLines = const [],
    this.verticalLines = const [],
    this.onLineTouch,
  });

  final List<ChartLine> chartLines;
  final AxisTitles? leftTitles;
  final AxisTitles? bottomTitles;
  final Widget Function(double, TitleMeta)? leftTitleRenderer;
  final Widget Function(double, TitleMeta)? bottomTitleRenderer;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;
  final double? height;
  final double? width;
  final List<double> horizontalLines;
  final List<double> verticalLines;
  final Function(LineTouchResponse?, double? firstX)? onLineTouch;

  List<HorizontalLine> get compiledHorizontalLines =>
      getHorizontalLines(horizontalLines);

  List<VerticalLine> get compiledVerticalLines =>
      getVerticalLines(verticalLines, borderLineColor, false);

  List<LineChartBarData> getLineBarsData() {
    List<LineChartBarData> items = [];
    for (ChartLine line in chartLines) {
      items.add(
        LineChartBarData(
          belowBarData: BarAreaData(
            show: line.hasGradient,
            gradient: line.hasGradient
                ? LinearGradient(
                    colors: [
                      line.color.withOpacity(0.5),
                      line.color.withOpacity(0)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.5, 1.0],
                  )
                : null,
            color: line.color.withAlpha(100),
          ),
          isCurved: true,
          spots: line.chartData,
          color: line.color,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        chartRendererKey: GlobalKey(),
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchCallback: (p0, p1) {
              // Checking if the touch event is a tap up event
              if (p0.runtimeType == FlTapUpEvent) {
                // Calling the onLineTouch function if it is not null
                if (onLineTouch != null) {
                  onLineTouch!(p1, p1?.lineBarSpots?.first.x);
                }
              }
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: greyTextColor),
              left: BorderSide(color: Colors.transparent),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: greyTextColor),
            ),
          ),
          gridData: const FlGridData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: compiledHorizontalLines,
            verticalLines: compiledVerticalLines,
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: leftTitles ??
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: leftTitleRenderer ?? defaultGetTitle,
                  ),
                ),
            bottomTitles: bottomTitles ??
                AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: bottomTitleRenderer ?? defaultGetTitle,
                  ),
                ),
          ),
          clipData: const FlClipData.all(),
          lineBarsData: getLineBarsData(),
          minY: minY,
          minX: minX,
          maxX: maxX,
          maxY: maxY,
          baselineY: 100,
        ),
      ),
    );
  }
}

typedef ChartLine = ChartLineBase<FlSpot>;

class ChartLineBase<T> {
  final List<T> chartData;
  final Color color;
  final bool hasGradient;

  ChartLineBase({
    required this.chartData,
    this.color = Colors.black,
    this.hasGradient = true,
  });
}

List<HorizontalLine> getHorizontalLines(List<double> horizontalLinesValues,
    [Color? color, bool showLabels = true]) {
  color ??= settings.colors.limitValues;
  return horizontalLinesValues
      .map(
        (e) => HorizontalLine(
          label: HorizontalLineLabel(
            alignment: Alignment.topRight,
            padding: EdgeInsets.zero,
            show: showLabels,
            style: TextStyle(fontSize: 15, color: color),
            labelResolver: (value) => value.y.toInt().toString(),
          ),
          y: e,
          color: color,
          strokeWidth: 1,
        ),
      )
      .toList();
}

List<VerticalLine> getVerticalLines(List<double> horizontalLinesValues,
    [Color color = borderLineColor, bool showLabels = true]) {
  return horizontalLinesValues
      .map(
        (e) => VerticalLine(
          label: VerticalLineLabel(
            alignment: Alignment.topRight,
            padding: EdgeInsets.zero,
            show: showLabels,
            style: TextStyle(fontSize: 15, color: color),
            labelResolver: (value) => value.x.toInt().toString(),
          ),
          x: e,
          color: color,
          strokeWidth: 1,
        ),
      )
      .toList();
}
