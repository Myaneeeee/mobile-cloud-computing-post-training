import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/model/motorbike_model.dart';
import 'package:frontend/services/comment_service.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';

class DetailPage extends StatefulWidget {
  final Motorbike motorbike;

  const DetailPage({Key? key, required this.motorbike}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final TextEditingController _commentController = TextEditingController();
  late CommentService _commentService;
  List<dynamic> _comments = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _commentService = CommentService('http://10.0.2.2:3000');
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final comments = await _commentService.fetchComments(widget.motorbike.id);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleComment(String comment) async {
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    if (comment.length <= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment must be more than 5 characters')),
      );
      return;
    }

    final userIdString = await _storage.read(key: 'userId');
    if (userIdString == null) {
      setState(() {
        _error = 'User ID not found';
      });
      return;
    }

    final userId = int.parse(userIdString);

    try {
      await _commentService.postComment(widget.motorbike.id, userId, comment);
      _commentController.clear();
      _fetchComments();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment posted successfully')),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: $_error')),
      );
    }
  }

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
            child: Text('Harley-Davidson'),
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
                      'http://10.0.2.2:3000/${widget.motorbike.imageUrl}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.motorbike.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$ ${widget.motorbike.price}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.motorbike.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Leave a Comment',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _commentController,
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
                      _handleComment(_commentController.text);
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
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text('Error: $_error'))
                    : _comments.isEmpty
                        ? const Center(child: Text('No comments yet'))
                        : ListView.builder(
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              final comment = _comments[index];
                              return ListTile(
                                title: Text(comment['commentText']),
                                subtitle: Text(
                                    '${comment['username']} - ${comment['commentDate']}'),
                              );
                            },
                          ),
          ],
        ),
      ),
    );
  }
}
