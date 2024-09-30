
// ignore_for_file: prefer_final_fields

import 'pages/favorite.dart';
import 'pages/home.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final String username;
  const Homepage({super.key, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    const Home(),
    const Search(),
    FavoriteVehiclesWidget(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Auto',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 4),
                      blurRadius: 3,
                      color: Color.fromARGB(255, 149, 147, 147),
                    )
                  ],
                ),
              ),
              TextSpan(
                text: 'Bro',
                style: TextStyle(
                  color: Color.fromRGBO(255, 155, 4, 1),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 4),
                      blurRadius: 3,
                      color: Color.fromARGB(255, 149, 147, 147),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 3,
                  color: Color.fromRGBO(255, 155, 4, 1),
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Mostra la pagina corrispondente
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cerca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Preferiti',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(255, 155, 4, 1),
        unselectedItemColor: const Color.fromARGB(255, 122, 122, 122),
        onTap: _onItemTapped, // Aggiorna l'indice al tocco
      ),
    );
  }
}