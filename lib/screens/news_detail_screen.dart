// lib/screens/news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map article;
  const NewsDetailScreen({super.key, required this.article});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['source']?['name'] ?? "News")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['urlToImage'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(article['urlToImage']),
              ),
            const SizedBox(height: 16),
            Text(
              article['title'] ?? "No Title",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(article['author'] ?? "Unknown Author"),
            const SizedBox(height: 10),
            Text(article['description'] ?? "No Description"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _openUrl(article['url']),
              child: const Text("Read Full Article"),
            ),
          ],
        ),
      ),
    );
  }
}
