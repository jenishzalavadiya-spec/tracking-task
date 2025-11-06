// import 'package:flutter/material.dart';
//
// class MonthlyGraphWidget extends StatefulWidget {
//   final Map<DateTime, dynamic> data;
//   const MonthlyGraphWidget({super.key, required this.data});
//
//   @override
//   State<MonthlyGraphWidget> createState() => _MonthlyGraphWidgetState();
// }
//
// Color getColor(double hours) {
//   if (hours == 0) return Colors.grey;
//   if (hours < 2) return Colors.purple.shade200;
//   if (hours < 4) return Colors.purple.shade400;
//   if (hours < 6) return Colors.purple.shade600;
//   if (hours < 8) return Colors.purple.shade700;
//   return Colors.deepPurple;
// }
//
// class _MonthlyGraphWidgetState extends State<MonthlyGraphWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final dayInMonth = DateTime(now.year, now.month + 1, 0).day;
//     return GridView.builder(
//       padding: EdgeInsets.all(10),
//       shrinkWrap: true,
//       physics: ScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 8,
//         crossAxisSpacing: 6,
//         mainAxisSpacing: 6,
//         childAspectRatio: 1,
//       ),
//       itemCount: dayInMonth,
//       itemBuilder: (context, index) {
//         final date = DateTime(now.year, now.month, index + 1);
//         final double hours = widget.data[date] ?? 0;
//
//         return Tooltip(
//           message: "${date.day}/${date.month} → ${hours.toStringAsFixed(1)}h",
//           child: Container(
//             decoration: BoxDecoration(
//               color: getColor(hours),
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class YearlyGraphWidget extends StatelessWidget {
//   final Map<DateTime, double> data;
//   const YearlyGraphWidget({super.key, required this.data});
//
//   Color getColor(double hours) {
//     if (hours == 0) return Colors.grey.shade300;
//     if (hours < 2) return Colors.purple.shade200;
//     if (hours < 4) return Colors.purple.shade400;
//     if (hours < 6) return Colors.purple.shade600;
//     if (hours < 8) return Colors.purple.shade700;
//     return Colors.deepPurple;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final yearStart = DateTime(now.year, 1, 1);
//     final yearEnd = DateTime(now.year + 1, 1, 0);
//
//     final totalDays = yearEnd.difference(yearStart).inDays + 1;
//     final totalColumns = (totalDays / 7).ceil();
//
//     List<String> month = [
//       "Jun",
//       "Feb",
//       "Mar",
//       "Apr",
//       "May",
//       "Jun",
//       "Jul",
//       "Aug",
//       "Sep",
//       "Otc",
//       "Nov",
//       "Dec",
//     ];
//     List<String> week = ["Mon", "Tud", "Wed", "Ted", "Fir", "Sut", "Sun"];
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(totalColumns, (columnIndex) {
//           return Column(
//             children: List.generate(7, (rowIndex) {
//               final dayIndex = columnIndex * 7 + rowIndex;
//
//               if (dayIndex >= totalDays) {
//                 return SizedBox(width: 14, height: 14);
//               }
//
//               final date = yearStart.add(Duration(days: dayIndex));
//               final hours =
//                   data[DateTime(date.year, date.month, date.day)] ?? 0;
//
//               return Tooltip(
//                 message:
//                     "${date.day}/${date.month}/${date.year} → ${hours.toStringAsFixed(1)}h",
//                 child: Container(
//                   margin: const EdgeInsets.all(2),
//                   width: 14,
//                   height: 14,
//                   decoration: BoxDecoration(
//                     color: getColor(hours),
//                     borderRadius: BorderRadius.circular(3),
//                   ),
//                 ),
//               );
//             }),
//           );
//         }),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class YearlyGraphWidget extends StatelessWidget {
  final Map<DateTime, double> data;
  const YearlyGraphWidget({super.key, required this.data});

  Color getColor(double hours) {
    if (hours == 0) return Colors.grey.shade300;
    if (hours < 3) return Colors.purple.shade200;
    if (hours < 5) return Colors.purple.shade400;
    if (hours < 6) return Colors.purple.shade600;
    if (hours < 8) return Colors.purple.shade700;
    return Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    final daysInYear =
        DateTime(now.year + 1, 1, 0).difference(yearStart).inDays + 1;

    final columns = (daysInYear / 7).ceil();

    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    int? lastShownMonth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Month Names (Only once per month)
          Transform.translate(
            offset: Offset(30, 0),
            child: Row(
              children: List.generate(columns, (c) {
                final date = yearStart.add(Duration(days: c * 7));
                final month = date.month;

                String text = "";
                if (lastShownMonth != month) {
                  text = months[month - 1];
                  lastShownMonth = month;
                }

                return SizedBox(
                  width: 18,
                  height: 19,
                  child: Text(
                    textAlign: TextAlign.center,
                    text,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Weekday Labels
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  return SizedBox(
                    height: 19,
                    width: 28,
                    child: Text(
                      weekDays[i],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(width: 4),

              // ✅ Heatmap Blocks
              Transform.translate(
                offset: Offset(0, 0),
                child: Row(
                  children: List.generate(columns, (c) {
                    return Column(
                      children: List.generate(7, (r) {
                        final dayIndex = c * 7 + r;
                        if (dayIndex >= daysInYear) {
                          return const SizedBox(width: 15, height: 15);
                        }

                        final date = yearStart.add(Duration(days: dayIndex));
                        final key = DateTime(date.year, date.month, date.day);
                        final hours = data[key] ?? 0.0;

                        return Tooltip(
                          message:
                              "${date.day}/${date.month}/${date.year} → ${hours.toStringAsFixed(1)}h",
                          child: Container(
                            alignment: Alignment(10, 0),
                            margin: const EdgeInsets.all(2),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: getColor(hours),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
