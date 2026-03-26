import 'package:flutter/material.dart';
import '../local_storage.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController habitController = TextEditingController();

  String selectedColor = "Amber";
  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    loadStoredHabits();
  }

  void loadStoredHabits() async {
    final profile = await LocalStorage.getUserProfile();

    if (profile != null && profile["habits"] is List) {
      setState(() {
        habits = (profile["habits"] as List)
            .map((h) => {"title": h, "color": _mapColor("Amber")})
            .toList();
      });
    }
  }

  void addHabit() async {
    final title = habitController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      habits.add({
        "title": title,
        "color": _mapColor(selectedColor),
      });
    });

    await saveAllHabits();
    habitController.clear();
  }

  void deleteHabit(int index) async {
    setState(() {
      habits.removeAt(index);
    });

    await saveAllHabits();
  }

  Future<void> saveAllHabits() async {
    final profile = await LocalStorage.getUserProfile() ?? {};

    profile["habits"] = habits.map((h) => h["title"]).toList();

    await LocalStorage.saveUserProfile(profile);
  }

  Color _mapColor(String color) {
    switch (color) {
      case "Green":
        return Colors.green;
      case "Amber":
        return Colors.amber;
      case "Orange":
        return Colors.orange;
      case "Teal":
        return Colors.teal;
      case "Purple":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Habits"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Habit Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: habitController,
              decoration: const InputDecoration(
                hintText: "Enter habit name",
              ),
            ),
            const SizedBox(height: 20),
            const Text("Select Color:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedColor,
              items: ["Green", "Amber", "Orange", "Teal", "Purple"]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => selectedColor = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addHabit,
              child: const Text("Add Habit"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: habit["color"],
                      ),
                      title: Text(habit["title"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteHabit(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to List"),
            ),
          ],
        ),
      ),
    );
  }
}