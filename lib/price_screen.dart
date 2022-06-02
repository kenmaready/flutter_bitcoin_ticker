import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
//
import 'services/coin_api.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String baseCurrency = 'BTC';
  String quoteCurrency = 'USD';
  double exchangeRate = 0.00;

  void _handleSelectBaseCurrency(String newBaseCurrency) {
    if (newBaseCurrency != baseCurrency) {
      setState(() => baseCurrency = newBaseCurrency);
    }
  }

  void _handleSelectQuoteCurrency(String newQuoteCurrency) {
    if (newQuoteCurrency != quoteCurrency) {
      setState(() => quoteCurrency = newQuoteCurrency);
    }
  }

  void _getExchangeRate() async {
    double newExchangeRate = await CoinAPI()
        .getExchangeRate(base: baseCurrency, quote: quoteCurrency);
    setState(() => exchangeRate = newExchangeRate);
  }

  Widget selector({List<String> items, Function handler, String value}) {
    return Platform.isIOS
        ? CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (index) => handler(items[index]),
            children: items.map((item) => Text(item)).toList(),
            scrollController:
                FixedExtentScrollController(initialItem: items.indexOf(value)),
          )
        : DropdownButton<String>(
            items: items
                .map((item) => DropdownMenuItem(child: Text(item), value: item))
                .toList(),
            value: value,
            onChanged: (value) => handler(value),
          );
  }

  @override
  void initState() {
    super.initState();
    _getExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${exchangeRate.toStringAsFixed(5)} $quoteCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(onPressed: _getExchangeRate, child: Text('Get Data')),
          Row(
            children: [
              Expanded(
                child: Container(
                    height: 150.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30.0),
                    color: Colors.lightBlue,
                    child: selector(
                      items: cryptoList,
                      handler: _handleSelectBaseCurrency,
                      value: baseCurrency,
                    )),
              ),
              Expanded(
                child: Container(
                    height: 150.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30.0),
                    color: Colors.lightBlue,
                    child: selector(
                      items: currenciesList,
                      handler: _handleSelectQuoteCurrency,
                      value: quoteCurrency,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
