import 'package:flutter/material.dart';

Widget btns({onpress, String? title, color, var groupvalue, var value}) {
  return InkWell(
    onTap: onpress,
    child: Container(
      width: 150,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$title",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          InkWell(
              onTap: onpress,
              child: Radio(
                  activeColor: Colors.green,
                  value: value,
                  groupValue: groupvalue,
                  onChanged: (value) {})),
        ],
      ),
    ),
  );
}
