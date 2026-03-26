import 'package:flutter/material.dart';
import '../local_storage.dart';
import '../country_list.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  double age = 25;
  String selectedCountry = "";
  List<String> countries = [];
  bool loadingCountries = true;

  final List<String> allHabits = [
    "Wake Up Early",
    "Workout",
    "Drink Water",
    "Meditate",
    "Read a Book",
    "Practice Gratitude",
    "Sleep 8 Hours",
    "Eat Healthy",
    "Journal",
    "Walk 10,000 Steps",
  ];

  final Set<String> selectedHabits = {};
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  void loadCountries() async {
    countries = await CountryList.loadCountries();

    setState(() {
      loadingCountries = false;
      selectedCountry = countries.first;
    });
  }

  void _toggleHabit(String habit) {
    setState(() {
      if (selectedHabits.contains(habit)) {
        selectedHabits.remove(habit);
      } else {
        selectedHabits.add(habit);
      }
    });
  }

  void _register() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();

    if (name.isEmpty || username.isEmpty) {
      setState(() {
        errorMessage = "Name and username cannot be empty.";
      });
      return;
    }

    if (selectedHabits.isEmpty) {
      setState(() {
        errorMessage = "Please select at least one habit.";
      });
      return;
    }

    final profile = {
      "name": name,
      "username": username,
      "age": age.toInt(),
      "country": selectedCountry,
      "habits": selectedHabits.toList(),
    };

    await LocalStorage.saveUserProfile(profile);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage != null) ...[
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 12),
              ],

              const Text("Name"),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
              const SizedBox(height: 12),

              const Text("Username"),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: "Enter your username",
                ),
              ),
              const SizedBox(height: 16),

              Text("Age: ${age.toInt()}"),
              Slider(
                value: age,
                min: 10,
                max: 80,
                divisions: 70,
                label: age.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text("Country"),
              loadingCountries
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButton<String>(
                      value: selectedCountry,
                      isExpanded: true,
                      items: countries
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCountry = value;
                          });
                        }
                      },
                    ),

              const SizedBox(height: 16),

              const Text(
                "Select Your Habits",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allHabits.map((habit) {
                  final selected = selectedHabits.contains(habit);
                  return ChoiceChip(
                    label: Text(habit),
                    selected: selected,
                    onSelected: (_) => _toggleHabit(habit),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}