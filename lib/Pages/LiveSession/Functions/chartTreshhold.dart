import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Widgets/Charts/chart.dart';

ChartLineBase<FlSpot> generateLowerTreshhold() {
  List<FlSpot> spots = List<FlSpot>.generate(1800, (index) {
    if (index < 600) {
      // Smooth cubic rise over the first 300 seconds (5 minutes)
      double x = index / 600.0;
      return FlSpot(
          index.toDouble(),
          20 +
              40 *
                  (x * x * (3 - 2 * x))); // Smooth cubic function from 20 to 60
    } else if (index < 1200) {
      // Gradual linear rise over the next 900 seconds (15 minutes)
      return FlSpot(
          index.toDouble(), 60 + ((index - 600) / 600) * 12); // 60 to 72
    } else {
      // Flat part over the last 600 seconds (10 minutes)
      return FlSpot(index.toDouble(), 72);
    }
  });

  // Create ChartLine instances
  late ChartLine line = ChartLineBase(
    chartData: spots,
    color: Colors.grey,
    hasGradient: false,
  );

  return line;
}

ChartLineBase<FlSpot> generateUpperTreshhold() {
  List<FlSpot> spots = List<FlSpot>.generate(1800, (index) {
    if (index < 600) {
      // Smooth cubic rise over the first 300 seconds (5 minutes)
      double x = index / 600.0;
      return FlSpot(
          index.toDouble(),
          65 +
              20 *
                  (x * x * (3 - 2 * x))); // Smooth cubic function from 60 to 85
    } else if (index < 1200) {
      // Gradual linear rise over the next 900 seconds (15 minutes)
      return FlSpot(
          index.toDouble(), 85 + ((index - 600) / 600) * 10); // 85 to 95
    } else {
      // Flat part over the last 600 seconds (10 minutes)
      return FlSpot(index.toDouble(), 95);
    }
  });

  // Create ChartLine instances
  late ChartLine line = ChartLineBase(
    chartData: spots,
    color: Colors.grey,
    hasGradient: false,
  );

  return line;
}
