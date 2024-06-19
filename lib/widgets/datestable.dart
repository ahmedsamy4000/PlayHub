import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/cubit/app_cubit.dart';

class DatesPerWeek extends StatelessWidget {
  const DatesPerWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        return Expanded(
            child: DateItem(
                BlocProvider.of<AppCubit>(context).daysPerWeek[index]));
      }),
    );
  }
}

class DateItem extends StatelessWidget {
  final DateTime date;
  const DateItem(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('EE');
    return Column(
      children: [
        Text(formatter.format(date)),
        CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(date.day.toString()),
        )
      ],
    );
  }
}
