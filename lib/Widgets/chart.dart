import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
 
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders().then((fetchedOrders) {
      setState(() {
        orders = fetchedOrders;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final DatabaseReference ordersRef =
          FirebaseDatabase.instance.ref('Orders');

      // Fetch data from the 'Orders' node
      final DataSnapshot snapshot = await ordersRef.get();

      if (snapshot.exists) {
        // Convert snapshot value to a Map and convert it to a list of orders
        Map<String, dynamic> products =
            Map<String, dynamic>.from(snapshot.value as Map);

        // Convert the map values (which are orders) into a list
        List<Map<String, dynamic>> ordersList = [];
        products.forEach((key, value) {
          ordersList.add(Map<String, dynamic>.from(value));
        });

        return ordersList;
      } else {
        print("No orders found!");
        return [];
      }
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> topProducts = orders
        .where((product) => product['quantity'] > 0)
        .toList()
      ..sort((a, b) => b['quantity'].compareTo(a['quantity']));

    if (topProducts.length > 5) {
      topProducts = topProducts.sublist(0, 5);
    }

    return Center(
        child: SizedBox(
      height: 300,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barGroups: topProducts.asMap().entries.map((entry) {
              int index = entry.key;
              double value = entry.value['quantity'].toDouble();
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: value,
                    color: Colors.blueGrey,
                    width: 16,
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < topProducts.length) {
                      return Text(
                        topProducts[value.toInt()]['name'],
                        style: const TextStyle(fontSize: 12),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
