import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart(
      {super.key,
      required this.chartData,
      required this.color,
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
      this.horizontalLines});

  final List<FlSpot> chartData;
  final AxisTitles? leftTitles;
  final AxisTitles? bottomTitles;
  final Widget Function(double, TitleMeta)? leftTitleRenderer;
  final Widget Function(double, TitleMeta)? bottomTitleRenderer;
  final Color color;
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;
  final double? height;
  final double? width;
  final List<HorizontalLine>? horizontalLines;

  List<HorizontalLine> getHorizontalLines() {
    var allitems = List<HorizontalLine>.empty(growable: true);

    var items = horizontalLines
        ?.map((e) => HorizontalLine(
              y: 100,
              color: Color.fromARGB(97, 0, 0, 0),
              strokeWidth: 1,
            ))
        .toList();
    if (items != null) {
      allitems.addAll(items);
    }
    return allitems;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: LineChart(
        chartRendererKey: GlobalKey(),
        LineChartData(
            gridData: const FlGridData(show: false),
            extraLinesData: ExtraLinesData(
              horizontalLines: horizontalLines ?? [],
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
            lineBarsData: [
              LineChartBarData(
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withAlpha(100),
                ),
                dotData: const FlDotData(
                  show: false,
                ),
                isCurved: true,
                spots: chartData,
                color: color,
              ),
              LineChartBarData(
                dotData: const FlDotData(
                  show: false,
                ),
                isCurved: true,
              ),
            ],
            minY: minY,
            minX: minX,
            maxX: maxX,
            maxY: maxY,
            baselineY: 100),
      ),
    );
  }
}

// ignore: must_be_immutable
