import 'package:flutter/material.dart';

class CustomOrderView extends StatelessWidget {
  final Map<String, dynamic>? orderDetails;
  const CustomOrderView({Key? key, this.orderDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imgUrl = orderDetails!['imgUrl'];
    final cakeDescription = orderDetails!['cakeDescription'];
    final shopAddress = orderDetails!['shopAddress'];
    final customType = orderDetails!['customType'];
    return Scaffold(
      appBar: AppBar(
        title: Text(shopAddress),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: Container(
                  width: double.infinity,
                  child: Image.network(
                    imgUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                              color: Colors.red, strokeWidth: 5),
                        );
                      }
                    },
                  ))),
          Flexible(
            child: SizedBox(height: 12),
          ),
          Divider(),
          Flexible(
            flex: 2,
            child: Text(
              cakeDescription,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
    );
  }
}
