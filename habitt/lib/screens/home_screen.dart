import 'package:flutter/material.dart';
import '../local_storage.dart';
import '../widgets/side_menu.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  List<Map<String, dynamic>> todo = [];
  List<Map<String, dynamic>> done = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final profile = await LocalStorage.getUserProfile();

    // Gastmodus
    if (profile == null || profile["habits"] == null) {
      setState(() {
        loading = false;
      });
      return;
    }

    
    final habits = profile["habits"] as List;

    setState(() {
      todo = habits
          .map((h) => {
                "title": h.toString(),
                "description": "Habit from profile",
              })
          .toList();
      loading = false;
    });
  }

  void addHabit() {
    setState(() {
      todo.add({
        "title": "New Habit ${todo.length + 1}",
        "description": "Generated habit"
      });
    });
  }

  void markDone(int index) {
    setState(() {
      done.add(todo[index]);
      todo.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),

      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text("Habitt"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: addHabit,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To Do ✏️",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  todo.isEmpty
                      ? const Text(
                          "Use the + button to create some habits!",
                          style: TextStyle(fontSize: 16),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: todo.length,
                            itemBuilder: (context, index) {
                              final item = todo[index];

                              return GestureDetector(
                                onHorizontalDragEnd: (_) => markDone(index),
                                child: Card(
                                  child: ListTile(
                                    title: Text(item["title"]),
                                    trailing:
                                        const Icon(Icons.chevron_right),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DetailScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                  const SizedBox(height: 20),

                  const Text(
                    "Done ☑️",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: done.isEmpty
                        ? const Text(
                            "Swipe right on an activity to mark as done",
                            style: TextStyle(fontSize: 16),
                          )
                        : ListView.builder(
                            itemCount: done.length,
                            itemBuilder: (context, index) {
                              final item = done[index];

                              return Card(
                                color: Colors.green.shade100,
                                child: ListTile(
                                  title: Text(item["title"]),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}