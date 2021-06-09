import 'package:flutter/material.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/utils/toast.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Future<double> _fetch;

  @override
  void initState() {
    _fetch = _fetchTransaction();
    super.initState();
  }

  Future<double> _fetchTransaction() async {
    return await HttpManager.getInstance().get("/api/v1/transactions/balance");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的钱包"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<double>(
        future: _fetch,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.done) {
            if (s.hasError) {
              return Text(s.error);
            } else {
              return Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text("我的资产",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            s.data.toStringAsFixed(2),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: MaterialButton(
                      height: 44,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text("提现"),
                      onPressed: () {
                        Toast.show("暂未实现");
                      },
                      minWidth: double.infinity,
                    ),
                  )
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
