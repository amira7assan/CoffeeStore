import 'package:ecommerce/Model/Category_model.dart';
import 'package:ecommerce/Model/Products_model.dart';
import 'package:http/http.dart' as http;

// class RemoteServices {
//   static var client = http.Client();
//   static Future<List<Product>?> fetchProducts() async {
//     var response =
//         await client.get(Uri.parse("https://fakestoreapi.com/products"));
//     if (response.statusCode == 200) {
//       var json = response.body;
//       return productFromJson(json);
//     } else {
//       print("error response: ${response.statusCode}");
//     }
//     return null;
//   }
// static Future<List<String>?> fetchCategories() async {
//     var response =
//         await client.get(Uri.parse("https://fakestoreapi.com/products/categories"));
//     if (response.statusCode == 200) {
//       var json = response.body;
//       return categoryFromJson(json);
//     } else {
//       print("error response: ${response.statusCode}");
//     }
//     return null;
//   }

// }
