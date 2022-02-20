import 'package:flutter/material.dart';
class ReusableTextForm extends StatelessWidget {
  ReusableTextForm({this.onChanged,this.txt1,this.validator,});
  final String txt1;
  final Function onChanged;
  final validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(

          labelText: "$txt1 :",
          border: OutlineInputBorder(),


        ),
      ),
    );
  }
}
