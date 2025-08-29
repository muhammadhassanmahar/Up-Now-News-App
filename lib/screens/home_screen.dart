import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // ✅ super.key use kiya

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> articles = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = "ec1c17aaa71243b9b788486ed7715f49"; // 👈 API Key
    final url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey",
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
        debugPrint("❌ Error: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("⚠️ Exception: $e");
    }
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UpNow - Top Headlines")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : articles.isEmpty
              ? const Center(child: Text("No news available"))
              : ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (_, i) {
                    final article = articles[i];
                    final imageUrl = article['urlToImage'];
                    final title = article['title'] ?? "No Title";
                    final desc = article['description'] ?? "No Description";

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  color: Colors.grey,
                                  child: const Icon(Icons.broken_image),
                                ),
                              )
                            : Container(
                                width: 80,
                                color: Colors.grey,
                                child: const Icon(Icons.image_not_supported),
                              ),
                        title: Text(title),
                        subtitle: Text(
                          desc,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _openUrl(article['url']),
                      ),
                    );
                  },
                ),
    );
  }
}
