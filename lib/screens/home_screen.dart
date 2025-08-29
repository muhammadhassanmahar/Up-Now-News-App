import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

    const apiKey = "ec1c17aaa71243b9b788486ed7715f49"; // 👈 API Key
    final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&category=$selectedCategory&apiKey=$apiKey",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        articles = data['articles'];
        loading = false;
      });
    } else {
      debugPrint("Error: ${res.statusCode}");
      setState(() => loading = false);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UpNow - Top Headlines"),
        centerTitle: true,
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
                    setState(() {
                      selectedCategory = cat;
                    });
                    fetchNews();
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[300],
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
                                ? Image.network(
                                    article['urlToImage'],
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
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
