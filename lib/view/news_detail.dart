import 'package:flutter/material.dart';
import 'webview.dart';
// Import the WebViewPage

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article['title'] ?? 'News Detail',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image if available
            if (article['urlToImage'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article['urlToImage'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Title
            Text(
              article['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),

            // Author and Source
            if (article['author'] != null || article['source'] != null)
              Text(
                'By ${article['author'] ?? 'Unknown Author'} • ${article['source']?['name'] ?? 'Unknown Source'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),

            // Published Date
            if (article['publishedAt'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Published on ${DateTime.tryParse(article['publishedAt']) != null ? DateTime.parse(article['publishedAt']).toLocal().toString().split(' ')[0] : article['publishedAt']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

            const Divider(height: 30, color: Colors.grey),

            // Content
            Text(
              _replaceTrailingDigitsWithReadMore(
                  article['content'] ?? 'No Content Available'),
              style: const TextStyle(
                fontSize: 20,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // "Read More" Button
            if (article['url'] != null)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(url: article['url']),
                      ),
                    );
                  },
                  child: const Text(
                    'Read Full Article',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Replaces any trailing `+digits` with "Read more..."
  String _replaceTrailingDigitsWithReadMore(String content) {
    return content.replaceAll(RegExp(r'\+\d+$'), 'Read more...').trim();
  }
}
