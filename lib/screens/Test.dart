import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playhub/cubit/app_cubit.dart';

class PieChartWidget extends StatelessWidget {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: List.generate(cubit.playgroundStatistics.length, (index) {
      final data = cubit.playgroundStatistics[index];
      final category = data.keys.first;
      final count = data.values.first;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: count.toDouble(),
        title: '$category\n${(count)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 100,
          ),
        ),
      ),
    );
  }
}