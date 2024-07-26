// items_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/api/motorbike_service.dart';
import 'package:frontend/model/motorbike_model.dart';
import 'package:frontend/pages/detail_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:frontend/auth_guard.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  int _currentIndex = 1;
  late Future<List<Motorbike>> futureMotorbikes;

  @override
  void initState() {
    super.initState();
    futureMotorbikes = MotorbikeService().fetchMotorbikes();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Harley-Davidboy'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 5),
                icon: Icon(
                  themeProvider.themeData.brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Motorbike>>(
        future: futureMotorbikes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No motorbikes available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final motorbike = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        'http://10.0.2.2:3000/${motorbike.imageUrl}',
                        height: 150.0,
                        width: 100.0,
                      ),
                    ),
                    title: Text(motorbike.name),
                    subtitle: Text('\$ ${motorbike.price}'),
                    onTap: () {
                      // Navigate to DetailPage with motorbike details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(motorbike: motorbike),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
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
