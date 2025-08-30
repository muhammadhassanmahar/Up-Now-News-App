import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged; // 🔥 Theme toggle callback

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List articles = [];
  bool loading = true;
  String selectedCategory = "general"; // Default category

  final List<String> categories = [
    "general",
    "business",
    "entertainment",
    "health",
    "science",
    "sports",
    "technology",
  ];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() => loading = true);

    final apiKey = dotenv.env['NEWS_API_KEY']; // 🔒 Secure from .env
    final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&category=$selectedCategory&apiKey=$apiKey",
    );

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          articles = data['articles'] ?? [];
          loading = false;
        });
      } else {
        _showSnackBar("Error: ${res.statusCode}");
        setState(() => loading = false);
      }
    } catch (e) {
      _showSnackBar("Something went wrong!");
      setState(() => loading = false);
    }
  }

  Future<void> _openUrl(String? url) async {
    if (url == null) {
      _showSnackBar("No URL available");
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar("Could not launch URL");
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UpNow - Top Headlines"),
        centerTitle: true,
        actions: [
          // 🔥 Theme toggle switch
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (val) {
              if (widget.onThemeChanged != null) {
                widget.onThemeChanged!(val);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔥 Category Selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = cat == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedCategory = cat);
                    fetchNews();
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        cat.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔥 News List
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchNews,
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (_, i) {
                        final article = articles[i];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: article['urlToImage'] != null
                                ? FadeInImage.assetNetwork(
                                    placeholder: 'assets/placeholder.Png',
                                    image: article['urlToImage'],
                                    width: 80,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                            title: Text(
                              article['title'] ?? "No Title",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              article['description'] ?? "No Description",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _openUrl(article['url']),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
