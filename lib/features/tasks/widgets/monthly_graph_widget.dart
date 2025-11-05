import 'package:flutter/material.dart';

class MonthlyGraphWidget extends StatefulWidget {
  final Map<DateTime, dynamic> data;
  const MonthlyGraphWidget({super.key, required this.data});

  @override
  State<MonthlyGraphWidget> createState() => _MonthlyGraphWidgetState();
}

Color getColor(double hours) {
  if (hours == 0) return Colors.grey;
  if (hours < 2) return Colors.purple.shade200;
  if (hours < 4) return Colors.purple.shade400;
  if (hours < 6) return Colors.purple.shade600;
  if (hours < 8) return Colors.purple.shade700;
  return Colors.deepPurple;
}

class _MonthlyGraphWidgetState extends State<MonthlyGraphWidget> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayInMonth = DateTime(now.year, now.month + 1, 0).day;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(dayInMonth, (i) {
        final date = DateTime(now.year, now.month, i + 1);
        final double hours = widget.data[date] ?? 0;

        return Tooltip(
          message: "${date.day}/${date.month} → ${hours.toStringAsFixed(1)}h",
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: getColor(hours),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
