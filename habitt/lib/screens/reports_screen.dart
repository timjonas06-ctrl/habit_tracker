import 'package:flutter/material.dart';
import '../local_storage.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<String> habits = [];

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final profile = await LocalStorage.getUserProfile();
    final list = profile?["habits"] ?? [];

    setState(() {
      habits = List<String>.from(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: habits.isEmpty
            ? const Text("No habits found.")
            : ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(habits[index]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
