import 'package:ecommerce/Widgets/chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
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
        Map<String, dynamic> ordersData =
            Map<String, dynamic>.from(snapshot.value as Map);

        // Convert the map values (which are orders) into a list
        List<Map<String, dynamic>> ordersList = [];
        ordersData.forEach((key, value) {
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
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 50.0),
            child: Text(
              "Top Sellers",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const ChartScreen(),
          const Padding(
            padding: EdgeInsets.only(left: 50.0),
            child: Text(
              "Transactions Report",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                return ListTile(
                  title: Text(order['name'] ?? 'Unknown Product'),
                  subtitle: Text(
                    'Quantity: ${order['quantity']}, Total: ${order['total']}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
