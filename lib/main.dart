import 'package:aimify/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Todo {
  final String title;
  bool completed;

  Todo({
    required this.title,
    this.completed = false,
  });
}

class TodoCategory {
  final String name;
  final List<Todo> todos;

  TodoCategory({
    required this.name,
    List<Todo>? todos,
  }) : todos = todos ?? [];
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ToDoListPage(),
    );
  }
}

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  int _selectedIndex = 0;
  List<TodoCategory> categories = [
    TodoCategory(name: "Personal"),
    TodoCategory(name: "Work"),
  ];

  String _selectedCategory = 'Personal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body:
       Column(
        crossAxisAlignment: CrossAxisAlignment.end,
         children: [
          const SizedBox(height: 20), 
          Center(
            child: ElevatedButton(
              onPressed: _createCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set background color to black
                foregroundColor: Colors.white, // Set text color to white
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Set border radius to zero
                ),  
              ),
              child: const Text('Create New Category'),
              
            ),
          ),
          const SizedBox(height: 20), 
          Expanded(
           child : ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, categoryIndex) {
              final category = categories[categoryIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          category.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteCategory(categoryIndex);
                        },
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: category.todos.length,
                    itemBuilder: (context, todoIndex) {
                      final todo = category.todos[todoIndex];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (bool? value) {
                            setState(() {
                              todo.completed = value!;
                            });
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              category.todos.removeAt(todoIndex);
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(),
                  const Divider(),
                ],
              );
            },
                 ),),
         ],
       ),
       floatingActionButton: Container(
        width: 200, // Set the desired width here
        child: FloatingActionButton(
          onPressed: _addTodo,
          tooltip: 'Add Todo',
          backgroundColor: const Color.fromARGB(255, 129, 254, 225), // Set the background color here
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8), // Add some space between the icon and text
              Text('Add'), // Add your text here
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.3),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

 void _addTodo() async {
  final TextEditingController textController = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Todo', style: TextStyle(color: Color.fromARGB(255, 90, 223, 183))), // Set title color to purple
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set background color to black
      content: Container(
        color: const Color.fromARGB(255, 0, 0, 0), // Set background color of TextField container
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              style: const TextStyle(color: Colors.white), // Set text color to white
              decoration: const InputDecoration(
                labelText: 'Todo',
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((TodoCategory category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name, style: const TextStyle(color: Color.fromARGB(255, 130, 130, 130))), // Set text color to white
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color:Color.fromARGB(255, 90, 223, 183))), // Set text color to purple
        ),
        TextButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              final categoryIndex = categories.indexWhere((cat) => cat.name == _selectedCategory);
              if (categoryIndex != -1) {
                setState(() {
                  categories[categoryIndex].todos.add(Todo(
                    title: textController.text,
                  ));
                });
              }
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add', style: TextStyle(color:Color.fromARGB(255, 90, 223, 183))), // Set text color to purple
        ),
      ],
    ),
  );
}

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
    if (_selectedIndex == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );
    }
  }

  void _createCategory() async {
  final TextEditingController textController = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Create Category', style: TextStyle(color: Color.fromARGB(255, 94, 203, 198))), // Set title color to purple
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set background color to white
      content: Container(
        color: const Color.fromARGB(255, 0, 0, 0), // Set background color of TextField container
        child: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            labelStyle: TextStyle(color: Colors.white), // Set label text color to white
          ),
          style: const TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 94, 203, 198))), // Set text color to purple
        ),
        TextButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              // Create a new category
              final newCategory = TodoCategory(name: textController.text);
              setState(() {
                categories.add(newCategory);
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Create', style: TextStyle(color: Color.fromARGB(255, 94, 203, 198))), // Set text color to purple
        ),
      ],
    ),
  );
}

  void _deleteCategory(int index) {
  setState(() {
    categories.removeAt(index);
  });
}

}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/appbarlogo4.png'), // Replace with your image path
          fit: BoxFit.fill,
        ),
      ),
      child: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(0, 255, 229, 229), // Make the app bar transparent
      ),
    );
  }
  }

