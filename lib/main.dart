import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'dart:ui';
import 'goldrate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(GoldRate());
}

class GoldRate extends StatefulWidget {
  @override
  _GoldRateState createState() => _GoldRateState();
}

class _GoldRateState extends State<GoldRate> {
  final List<Feature> features = [
    Feature(
      title: "Up",
      color: Colors.green[200],
      data: [0.3, 0.6, 0.8, 0.9, 1, 1.2],
    ),
    Feature(
      title: "Down",
      color: Colors.red[200],
      data: [1, 0.8, 0.6, 0.7, 0.3, 0.1],
    ),
  ];
  Future<goldrate> futuregold;
  String name = "-", price = "-", sellingPrice = "-";
  List<double> prices;

  @override
  void initState() {
    localData();

    super.initState();
  }

  Future<goldrate> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://paytm.com/papi/v2/gold/product-portfolio?channel=WEB&version=2&child_site_id=1&site_id=1'));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data =
            new Map<String, dynamic>.from(json.decode(response.body));
        List<dynamic> dataValue = data['portfolio']['product_level'];
        if (dataValue.isNotEmpty) {
          setState(() {
            name = dataValue[0]['name'].toString();
            price = dataValue[0]['price_per_gm'].toString();
            sellingPrice = dataValue[0]['sell_price_per_gm'].toString();
            prices.add(double.parse(dataValue[0]['price_per_gm']));
            setdata(prices);
          });
        }
      } catch (e) {}
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<List<double>> localData() async {
    //get
    final prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("prices");
    if (list != null && list.isNotEmpty) {
      List<double> returnList = [];
      for (var item in list) {
        returnList.add(double.parse(item));
      }
      prices = returnList;
      fetchData();
    }
  }

  Future setdata(List<double> data) async {
    //put
    final prefs = await SharedPreferences.getInstance();
    List<String> storeData = [];
    for (var item in data) {
      storeData.add(item.toString());
    }
    prefs.setStringList("prices", storeData);
  }

  @override
  Widget build(BuildContext context) {
    if (prices == null || prices.isEmpty) {
      prices = [1.0];
    }
    var max =
        prices.reduce((value, element) => value > element ? value : element);
    List<double> ratios = [];

    for (var item in prices) {
      ratios.add(item / max);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              elevation: 19,
              backgroundColor: Colors.blue[100],
              toolbarHeight: 100,
              title: Text(
                "GoldRate",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                fetchData();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30)),
                        Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w600),
                        ),
                        Text(name.toString(), style: TextStyle(fontSize: 20)),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30)),
                        Text(
                          "Goldrate ",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          price.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30)),
                        Text(
                          "Selling Price",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w600),
                        ),
                        Text(sellingPrice.toString(),
                            style: TextStyle(fontSize: 20)),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30)),
                        LineGraph(
                          features: [
                            Feature(
                              title: "Gold Rate",
                              color: Colors.green[200],
                              data: ratios,
                            )
                          ],
                          size: Size(440, 250),
                          labelX: [
                            'Time 1',
                            'Time 1',
                            'Time 1',
                            'Time 1',
                            'Time 1',
                          ],
                          labelY: ['GoldRate'],
                          // showDescription: true,
                          graphColor: Colors.black,
                          // descriptionHeight: 1000,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
