import 'package:flutter/material.dart';

  BottomNavigationBar bottomAppBar(BuildContext context,int index) {
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text(''))
      ],
      onTap: (index) {
        switch (index) {
          case 0:
          Navigator.of(context).pushNamed('/');
            break;
          case 1:
           Navigator.of(context).pushNamed('/favorites');
            break;
          case 2:
          Navigator.of(context).pushNamed('/userProfile');
            break;

        }
      },
    );
  }