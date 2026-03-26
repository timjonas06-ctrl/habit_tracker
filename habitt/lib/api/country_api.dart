import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryApi {
  static Future<List<String>> fetchCountries() async {
    final url = Uri.parse("https://restcountries.com/v3.1/all");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((country) => country["name"]["common"].toString())
          .toList()
        ..sort();
    } else {
      throw Exception("Failed to fetch countries");
    }
  }
}