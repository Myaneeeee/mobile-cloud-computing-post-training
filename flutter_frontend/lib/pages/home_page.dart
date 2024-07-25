import 'package:flutter/material.dart';
import 'package:frontend/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Set the initial index to 0 (Home)

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harley-Davidboy'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Toggle Theme') {
                themeProvider.toggleTheme();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Toggle Theme',
                  child: Text('Toggle Theme'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Welcome, User",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
              ),
              items: [
                'assets/images/carousel1.png',
                'assets/images/carousel2.png',
                'assets/images/carousel3.png',
              ]
                  .map((item) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == _currentIndex) {
            // Do nothing if the same item is tapped
            return;
          }
          switch (index) {
            case 0:
              AuthGuard().navigateTo(context, '/home');
              break;
            case 1:
              AuthGuard().navigateTo(context, '/items');
              break;
            case 2:
              AuthGuard().navigateTo(context, '/profile');
              break;
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
