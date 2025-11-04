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

class WeeklyChart extends StatelessWidget {
  final Map<String, int> data;
  const WeeklyChart({super.key, required this.data});

  double toHours(int sec) => sec / 3600;

  @override
  Widget build(BuildContext context) {
    final sortedKeys = data.keys.toList()..sort(); // ✅ Sort dates
    final values = sortedKeys.map((e) => toHours(data[e]!)).toList();

    final spots = List.generate(sortedKeys.length, (i) {
      return FlSpot(i.toDouble(), values[i]);
    });

    final maxY = (values.reduce((a, b) => a > b ? a : b) + 1).ceilToDouble();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xffE6E7EB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const Text(
                "dsa",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 13),
              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    borderData: FlBorderData(show: false),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(strokeWidth: 1, color: Colors.grey.shade300),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.amber.shade700,
                        dotData: FlDotData(show: true), // ✅ no dots
                      ),
                    ],

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      // ✅ Y axis "Hours Per Day"
                      leftTitles: AxisTitles(
                        axisNameWidget: Text(
                          "Hours",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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

                      // ✅ X axis "Days"
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text(
                          "Days",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        axisNameSize: 28,
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final i = value.toInt();
                            if (i < 0 || i >= sortedKeys.length) {
                              return const SizedBox();
                            }
                            return Text(
                              sortedKeys[i].split("-").last,
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),

                    // ✅ Disable tooltips for clean design
                    lineTouchData: LineTouchData(enabled: false),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
