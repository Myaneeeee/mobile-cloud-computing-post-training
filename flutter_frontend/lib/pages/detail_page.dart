import 'package:flutter/material.dart';
import 'package:frontend/model/motorbike_model.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';

class DetailPage extends StatelessWidget {
  final Motorbike motorbike;

  const DetailPage({Key? key, required this.motorbike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: theme.appBarTheme.elevation,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Harley-Davidboy'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode ? Colors.white : Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: isDarkMode ? Colors.white : Colors.grey[700],
            labelColor: isDarkMode ? Colors.white : Colors.grey[700],
            unselectedLabelColor: isDarkMode ? Colors.grey : Colors.grey[400],
            tabs: const [
              Tab(
                icon: Icon(Icons.info),
                text: 'Product',
              ),
              Tab(
                icon: Icon(Icons.comment),
                text: 'Comments',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Product tab content
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'http://10.0.2.2:3000/${motorbike.imageUrl}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    motorbike.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$ ${motorbike.price}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    motorbike.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Leave a Comment',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Comment',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 14.0),
                    ),
                    onSubmitted: (String comment) {
                      _handleComment(comment);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _handleComment('');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Submit Comment'),
                  ),
                ],
              ),
            ),
            // Comments tab content
            const Center(
              child: Text("Comments"),
            ),
          ],
        ),
      ),
    );
  }

  void _handleComment(String comment) {}
}
