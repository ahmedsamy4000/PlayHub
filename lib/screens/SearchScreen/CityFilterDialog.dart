import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CityFilterDialog extends StatelessWidget {
  final Function(String) onCitySelected;

  CityFilterDialog({required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Select City', style: TextStyle(color: Colors.white)),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('All', style: TextStyle(color: Colors.white)),
              onTap: () {
                onCitySelected('All');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Cairo', style: TextStyle(color: Colors.white)),
              onTap: () {
                onCitySelected('Cairo');
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Alex', style: TextStyle(color: Colors.white)),
              onTap: () {
                onCitySelected('Alex');
                Navigator.of(context).pop();
              },
            ),
            // Add more cities as needed
          ],
        ),
      ),
    );
  }
}
