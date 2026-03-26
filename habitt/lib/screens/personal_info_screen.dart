import 'package:flutter/material.dart';
import '../local_storage.dart';
import '../api/country_api.dart';
import '../country_list.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  double age = 25;
  String selectedCountry = "Germany";
  List<String> countries = [];

  @override
  void initState() {
    super.initState();
    loadCountries();
    loadUserData();
  }

  Future<void> loadCountries() async {
    try {
      countries = await CountryApi.fetchCountries();
    } catch (_) {
      countries = CountryList.fallback;
    }
    setState(() {});
  }

  Future<void> loadUserData() async {
    final profile = await LocalStorage.getUserProfile();

    if (profile != null) {
      nameController.text = profile["name"] ?? "";
      usernameController.text = profile["username"] ?? "";
      age = (profile["age"] ?? 25).toDouble();
      selectedCountry = profile["country"] ?? "Germany";
    }

    setState(() {});
  }

  Future<void> saveUserData() async {
    final profile = await LocalStorage.getUserProfile() ?? {};

    profile["name"] = nameController.text.trim();
    profile["username"] = usernameController.text.trim();
    profile["age"] = age;
    profile["country"] = selectedCountry;

    await LocalStorage.saveUserProfile(profile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Info")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 20),
            Text("Age: ${age.toInt()}"),
            Slider(
              value: age,
              min: 10,
              max: 100,
              onChanged: (v) => setState(() => age = v),
            ),
            const SizedBox(height: 20),
            const Text("Country"),
            DropdownButton<String>(
              value: selectedCountry,
              items: countries
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCountry = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveUserData,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
