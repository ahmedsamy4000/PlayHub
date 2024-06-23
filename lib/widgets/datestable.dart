import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:playhub/cubit/app_cubit.dart';

class DatesPerWeek extends StatefulWidget {
  final String? playGroundId;
  final Function? handleDate;
  const DatesPerWeek(this.playGroundId, this.handleDate, {super.key});

  @override
  State<DatesPerWeek> createState() => _DatesPerWeekState();
}

class _DatesPerWeekState extends State<DatesPerWeek> {
  int _selectedIndex = 0;

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
              widget.handleDate!(
                DateFormat("dd-MM-yyyy")
                    .format(
                        BlocProvider.of<AppCubit>(context).daysPerWeek[index])
                    .toString(),
              );
              BlocProvider.of<AppCubit>(context).getPlaygroundById(
                widget.playGroundId!,
                DateFormat("dd-MM-yyyy")
                    .format(
                        BlocProvider.of<AppCubit>(context).daysPerWeek[index])
                    .toString(),
              );
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
