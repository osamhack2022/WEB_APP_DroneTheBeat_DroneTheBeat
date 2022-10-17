import 'package:flutter/material.dart';
import 'package:helloworld/pages/flight_request_page.dart';
import 'package:helloworld/styles.dart';

class CustomDropdownButton extends StatefulWidget {
  final String title;
  final List dropdownList;

  const CustomDropdownButton({required this.title, required this.dropdownList});

  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  late String dropdownValue;
  void initState() {
    super.initState();
    dropdownValue = widget.dropdownList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: overLine(),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  if (widget.dropdownList == armyList) {
                    dropdownValueArmy = dropdownValue;
                  } else if (widget.dropdownList == modelList) {
                    dropdownValueModel = dropdownValue;
                  }
                });
              },
              items: widget.dropdownList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
