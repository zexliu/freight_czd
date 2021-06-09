import 'package:flutter/material.dart';

class SelectButton extends StatefulWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final bool isSelected;
  final Color normalBackgroundColor;

  final Color selectedBackgroundColor;
  final Color normalBorderColor;
  final Color selectedBorderColor;
  final Color normalTextColor;
  final Color selectedTextColor;

  final Function onTap;

  SelectButton(
      {Key key,
      @required this.text,
      this.isSelected = false,
      this.onTap,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 12,
      this.normalBackgroundColor,
      this.selectedBackgroundColor,
      this.normalBorderColor,
      this.selectedBorderColor,
      this.normalTextColor,
      this.selectedTextColor})
      : super(key: key);

  @override
  _SelectButtonState createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  Color normalBackgroundColor;
  Color selectedBackgroundColor;
  Color normalBorderColor;
  Color selectedBorderColor;
  Color normalTextColor;
  Color selectedTextColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.normalBackgroundColor = widget.normalBackgroundColor != null
        ? widget.normalBackgroundColor
        : Colors.grey.shade200;
    this.selectedBackgroundColor = widget.selectedBackgroundColor != null
        ? widget.selectedBackgroundColor
        : Theme.of(context).primaryColor.withAlpha(20);
    this.normalBorderColor = widget.normalBorderColor != null
        ? widget.normalBorderColor
        : Colors.grey.shade200;
    this.selectedBorderColor = widget.selectedBorderColor != null
        ? widget.selectedBorderColor
        : Theme.of(context).primaryColor;
    this.normalTextColor =
        widget.normalTextColor != null ? widget.normalTextColor : Colors.black;
    this.selectedTextColor = widget.selectedTextColor != null
        ? widget.selectedTextColor
        : Theme.of(context).primaryColor;
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.isSelected
                  ? this.selectedBorderColor
                  : this.normalBorderColor),
          color: widget.isSelected
              ? this.selectedBackgroundColor
              : this.normalBackgroundColor,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
              color: (widget.isSelected
                  ? this.selectedTextColor
                  : this.normalTextColor),
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight),
          maxLines: 1,
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
