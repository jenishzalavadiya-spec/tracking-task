// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class WeeklyChart extends StatelessWidget {
//   final Map<String, int> data;
//   const WeeklyChart({super.key, required this.data});
//
//   double toHours(int sec) => sec / 3600;
//
//   @override
//   Widget build(BuildContext context) {
//     final keys = data.keys.toList();
//
//     return BarChart(
//       BarChartData(
//         minY: 0,
//         gridData: FlGridData(show: true),
//         borderData: FlBorderData(show: true),
//         barGroups: List.generate(keys.length, (i) {
//           final hours = toHours(data[keys[i]]!);
//           return BarChartGroupData(
//             x: i,
//             barRods: [
//               BarChartRodData(
//                 toY: hours,
//                 width: 14,
//                 borderRadius: BorderRadius.circular(4),
//                 color: Colors.blue,
//               ),
//             ],
//           );
//         }),
//         titlesData: FlTitlesData(
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           leftTitles: AxisTitles(
//             axisNameWidget: const Text("Hours"),
//             axisNameSize: 28,
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 40,
//               interval: 1,
//               getTitlesWidget: (value, _) {
//                 return Text(
//                   "${value.toInt()}h",
//                   style: const TextStyle(fontSize: 12),
//                 );
//               },
//             ),
//           ),
//           bottomTitles: AxisTitles(
//             axisNameWidget: const Text("Days"),
//             axisNameSize: 28,
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, _) {
//                 if (value.toInt() < 0 || value.toInt() >= keys.length) {
//                   return const SizedBox();
//                 }
//                 final date = keys[value.toInt()];
//                 final day = date.split("-").last; // '01', '02' etc.
//                 return Text(day, style: const TextStyle(fontSize: 12));
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model_task/task_model.dart';

class GraphWidget extends StatelessWidget {
  final Map<String, int> data;
  final TaskModel task;
  const GraphWidget({super.key, required this.data, required this.task});

  double toHours(int sec) => sec / 3600;

  @override
  Widget build(BuildContext context) {
    final sortedKeys = data.keys.toList()..sort();
    final values = sortedKeys.map((e) => toHours(data[e]!)).toList();

    final spots = List.generate(values.length, (i) {
      return FlSpot(i.toDouble(), values[i]);
    });

    final maxY = (values.reduce((a, b) => a > b ? a : b) + 1).ceilToDouble();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 24),
            color: Color(0xffE6E7EB),
            child: Column(
              children: [
                Text(
                  task.taskName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(task.description),
                SizedBox(height: 15),
                SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxY,
                      borderData: FlBorderData(show: false),

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 0.5,
                        getDrawingHorizontalLine: (value) =>
                            FlLine(strokeWidth: 5, color: Colors.grey.shade300),
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.purple.shade300,
                          dotData: FlDotData(show: true),
                        ),
                      ],

                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        leftTitles: AxisTitles(
                          axisNameWidget: Padding(
                            padding: EdgeInsets.only(left: 70),
                            child: Text(
                              "Hours",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          axisNameSize: 40,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, _) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),

                        bottomTitles: AxisTitles(
                          axisNameWidget: Padding(
                            padding: EdgeInsets.only(left: 70),
                            child: Text(
                              "Days",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          axisNameSize: 28,
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              int index = value.toInt();

                              if (value != index.toDouble()) {
                                return const SizedBox();
                              }

                              if (index < 0 || index >= sortedKeys.length) {
                                return const SizedBox();
                              }

                              return Text(
                                "${index + 1}",
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(enabled: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
