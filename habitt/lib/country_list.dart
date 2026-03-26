import 'api/country_api.dart';

class CountryList {
  static List<String> fallback = [
    "Germany",
    "France",
    "Spain",
    "Italy",
    "Australia",
  ];

  static Future<List<String>> loadCountries() async {
    try {
      return await CountryApi.fetchCountries();
    } catch (_) {
      return fallback;
    }
  }
}