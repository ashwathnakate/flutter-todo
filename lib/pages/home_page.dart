import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:to_do/data/database.dart';
import 'package:to_do/utils/dialogue_box.dart';
import 'package:to_do/utils/todo_tile.dart';
import 'package:to_do/data/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _mybox = Hive.box('mybox');

  // tododatabase
  ToDoDatabase db = ToDoDatabase();

  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool isDarkMode = false;

  @override
  void initState() {
    // if first time ever opening the app create the default data
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // data already exists
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          isDarkMode: isDarkMode,
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    // Filter tasks based on the search query
    List filteredTasks = db.toDoList
        .where(
            (task) => task[0].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: myDrawer(context),
      ),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor:
              isDarkMode ? colors.lightNavbarMain : colors.darkNavbarMain,
          shape: Border(
            bottom: BorderSide(
              color:
                  isDarkMode ? colors.lightNavbarStrip : colors.darkNavbarStrip,
              width: 3,
            ),
          ),
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            child: _isSearching
                ? buildSearchField()
                : Text(
                    "To-Do",
                    style: TextStyle(color: colors.lightTextIconAll),
                  ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  // Toggle the search field visibility
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      // Clear search query when closing the search field
                      _searchController.clear();
                      searchQuery = '';
                    }
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
      ),
      floatingActionButton: Material(
        color: colors.lightMaterialActionBtn,
        child: FloatingActionButton(
          backgroundColor: isDarkMode
              ? colors.lightFltActionBtnBg
              : colors.darkFltActionBtnBg,
          onPressed: createNewTask,
          elevation: 10,
          child: Icon(
            Icons.add,
            color: colors.lightTextIconAll,
            size: 30,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDarkMode ? colors.lightTopGradient : colors.darkTopGradient,
              isDarkMode
                  ? colors.lightBottomGradient
                  : colors.darkBottomGradient,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              isDarkMode: isDarkMode,
              taskName: filteredTasks[index][0],
              taskCompleted: filteredTasks[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ),
      ),
    );
  }

  Drawer myDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      backgroundColor: isDarkMode ? colors.lightDrawerBg : colors.darkDrawerBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 220, top: 30),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 30,
                color: colors.lightTextIconAll,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 300),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colors.lightTextIconAll,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 8.0),
                  child: Text(
                    'Hi there!👋',
                    style: TextStyle(
                      color: colors.lightTextIconAll,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  child: Text(
                    DateFormat.MMMMEEEEd().format(DateTime.now()),
                    style: TextStyle(
                      color: colors.lightTextIconAll,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Light Mode',
                style: TextStyle(color: colors.lightTextIconAll),
              ),
              Switch(
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: Colors.blue,
                activeTrackColor: Colors.grey,
                activeColor: Colors.black,
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  // Here, you can update the colors dynamically based on the selected mode
                  // For simplicity, we'll use a function to update the colors
                  updateColors();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "v1.0.1",
              style: TextStyle(color: colors.lightTextIconAll),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return Container(
      height: 50,
      width: 300,
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          setState(() {
            searchQuery = query;
          });
        },
        style: TextStyle(fontSize: 20.0, color: colors.lightTextIconAll),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          hintText: 'Search...',
          hintStyle: TextStyle(color: colors.lightTextIconAll.withOpacity(0.6)),
        ),
      ),
    );
  }

  Widget buildSearchTextField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: buildSearchField(),
    );
  }

  void updateColors() {
    setState(() {
      if (isDarkMode) {
        // Use dark mode colors
        colors.darkTopGradient = Color.fromARGB(255, 0, 0, 0);
        colors.darkBottomGradient = Color.fromARGB(255, 44, 40, 50);
        colors.darkNavbarMain = Color.fromARGB(201, 89, 95, 108);
        colors.darkNavbarStrip = Color.fromARGB(255, 61, 66, 76);
        colors.darkTodotileMain = Color.fromARGB(255, 44, 44, 44);
        colors.darkFltActionBtnBg = Color.fromARGB(204, 64, 64, 69);
        colors.darktMaterialActionBtn = Color.fromARGB(142, 18, 18, 19);
        colors.darkTextIconAll = Colors.white;
        colors.darkDrawerBg = Color.fromARGB(133, 28, 35, 41);
        colors.darkDialogueBox = Color.fromARGB(106, 0, 0, 0);
        colors.darkBtn = Color.fromARGB(255, 61, 66, 76);
      } else {
        // Use light mode colors
        colors.lightTopGradient = Color.fromARGB(255, 22, 150, 255);
        colors.lightBottomGradient = Color.fromARGB(255, 8, 105, 185);
        colors.lightNavbarStrip = Color.fromARGB(255, 169, 216, 255);
        colors.lightNavbarMain = Color.fromARGB(255, 154, 185, 248);
        colors.lightTodotileMain = Color.fromARGB(255, 87, 143, 255);
        colors.lightFltActionBtnBg = Color.fromARGB(204, 129, 170, 252);
        colors.lightMaterialActionBtn = Color.fromARGB(0, 27, 147, 246);
        colors.lightTextIconAll = Colors.white;
        colors.lightDrawerBg = Color.fromARGB(135, 163, 214, 255);
        colors.lightDialogueBox = Colors.blue.withOpacity(0.4);
        colors.lightBtn = Color.fromARGB(255, 77, 147, 251);
      }
    });
  }
}
