import 'package:flutter/material.dart';

class PayResultPage extends StatefulWidget {
  final bool isSuccess;

  PayResultPage(this.isSuccess);

  @override
  _PayResultPageState createState() => _PayResultPageState();
}

class _PayResultPageState extends State<PayResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("支付结果"),backgroundColor: Colors.white,),
      body: Column(
          children: [
            SizedBox(height: 60,width: MediaQuery.of(context).size.width,),
            Icon(Icons.error,color: widget.isSuccess ? Colors.green:Colors.grey,size: 80,),
            SizedBox(height: 15,),
            Text("${widget.isSuccess ? "支付成功":"支付失败"}",style: TextStyle(fontSize: 20),)
          ]
      ),
    );
  }
}
