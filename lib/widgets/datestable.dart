import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/cubit/app_cubit.dart';

class DatesPerWeek extends StatefulWidget {
  const DatesPerWeek({Key? key}) : super(key: key);

  @override
  _DatesPerWeekState createState() => _DatesPerWeekState();
}

class _DatesPerWeekState extends State<DatesPerWeek> {
  int _selectedIndex = 0; // Initially no item is selected

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        return Expanded(
          child: DateItem(
            date: BlocProvider.of<AppCubit>(context).daysPerWeek[index],
            isSelected: index == _selectedIndex,
            onTap: () {
              setState(() {
                print(BlocProvider.of<AppCubit>(context)
                    .daysPerWeek[index]
                    .toString());
                _selectedIndex = index;
              });
            },
          ),
        );
      }),
    );
  }
}

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('EE');

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(formatter.format(date)),
          CircleAvatar(
            backgroundColor: isSelected ? Colors.blue : Colors.white30,
            child: Text(
              date.day.toString(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
