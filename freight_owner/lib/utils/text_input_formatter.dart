
// 只允许输入小数
import 'package:flutter/services.dart';

class UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.01;

  int max;

  UsNumberTextInputFormatter([this.max = 9999]);

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    double number = strToFloat(value, defaultDouble);
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" &&
        value != defaultDouble.toString() &&
        number == defaultDouble) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    } else {
      if (number > max) {
        value = max.toString();
      }
      if (number < 0) {
        value = "0";
      }
      if (value.contains(".")) {
        int index = value.lastIndexOf(".");
        if (value.length - index > 3) {
          value = oldValue.text;
          selectionIndex = oldValue.selection.end;
        }
      }
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
