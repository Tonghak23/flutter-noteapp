import 'package:flutter/material.dart';
import 'package:flutter_noteapp/auth/user.dart';
import 'package:flutter_noteapp/pages/addnote.dart';
import 'package:flutter_noteapp/pages/home.dart';

class NavigateItem extends StatefulWidget {
  const NavigateItem({Key? key}) : super(key: key);

  @override
  State<NavigateItem> createState() => _NavigateItemState();
}

class _NavigateItemState extends State<NavigateItem> {
  List? _pages;
  //Current Page
  int _selectIndex = 0;
  @override
  void initState() {
    _pages = [
        Home(),
        AddNote(),
        User()
    ];
    super.initState();
  }
  void _selectedPage(int index) {
    setState(() {
        _selectIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages![_selectIndex],
        bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo[600],	
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), tooltip: 'Home',label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.note_add), tooltip: 'Feeds',label: 'Add Note'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), tooltip: 'Me',label: 'Me'),
      ],
        currentIndex: _selectIndex,
        onTap: _selectedPage,
        ),
    );
  }
}
