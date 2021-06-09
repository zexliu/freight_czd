import 'package:flutter/widgets.dart';

class EmptyPage extends StatelessWidget {
  final String image;

  final List<Widget> children;

  EmptyPage({Key key, this.image, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    children.insert(0, SizedBox(height: 80));
    children.insert(1, SizedBox(width: MediaQuery.of(context).size.width));
    if (this.image != null) {
      children.insert(2, Image.asset(image));
    }
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: children,
      ),
    );
  }
}
