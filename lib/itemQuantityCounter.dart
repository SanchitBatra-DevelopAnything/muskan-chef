import 'package:flutter/material.dart';

typedef void CountButtonClickCallBack(int count);

class CountButtonView extends StatefulWidget {
  final int itemIndex;
  final String orderId;
  final CountButtonClickCallBack onChange;
  final int count;
  final int max;

  const CountButtonView(
      {Key? key,
      required this.itemIndex,
      required this.orderId,
      required this.onChange,
      required this.max,
      required this.count})
      : super(key: key);

  @override
  _CountButtonViewState createState() => _CountButtonViewState();
}

class _CountButtonViewState extends State<CountButtonView> {
  int quantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateCount(int addValue) {
    if (quantity + addValue == 0) {
      setState(() {
        quantity = 0;
      });
    }
    if (quantity + addValue > 0) {
      setState(() {
        quantity += addValue;
      });
    }

    if (widget.onChange != null) {
      widget.onChange(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    var count = widget.count;
    setState(() {
      quantity = widget.count;
    });
    return SizedBox(
      width: 120.0,
      height: 50.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    updateCount(-1);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(22.0)),
                      width: 40.0,
                      child: Center(
                          child: Text(
                        '-',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )))),
              Container(
                child: Center(
                    child: Text(
                  '$quantity',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                )),
              ),
              GestureDetector(
                  onTap: () {
                    updateCount(1);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: Colors.black),
                      width: 40.0,
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )))),
            ],
          ),
        ),
      ),
    );
  }
}
