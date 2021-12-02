import 'package:flutter/material.dart';

import '../colors/colors.dart';

Widget formField(
  controller, {
  validation,
  readOnly,
  ontap,
  required String hinttext,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: TextFormField(
      autofocus: true,
      readOnly: readOnly ?? false,
      onTap: ontap,
      validator: validation,
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: hinttext,
          filled: true,
          fillColor: ConstantColors.textFieldColor),
    ),
  );
}
