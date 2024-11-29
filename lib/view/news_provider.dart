import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  final String _apiKey = '3fad3bb389304554a02f5500120d8d71';
  final String _baseUrl = 'https://newsapi.org/v2';

  List<dynamic> _articles = []; // Articles for the selected category or search
  List<dynamic> _allArticles = []; // Articles from all fetched categories
  bool _isDarkMode = false;

  List<dynamic> get articles =>
      _articles; // Get current category or search articles
  List<dynamic> get allArticles =>
      _allArticles; // Get all articles for global search
  bool get isDarkMode => _isDarkMode; // Dark mode status

  /// Fetch top headlines for a specific category (default: 'general')
  Future<void> fetchTopHeadlines({String category = 'general'}) async {
    final url =
        '$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles =
            data['articles']; // Update articles for the current category
        _addToAllArticles(data['articles']); // Add to global list
        notifyListeners();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Search for news articles by a specific query
  Future<void> searchNews(String query) async {
    final url = '$_baseUrl/everything?q=$query&apiKey=$_apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = data['articles']; // Update articles with search results
        notifyListeners();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Add fetched articles to the global list (`_allArticles`) without duplicates
  void _addToAllArticles(List<dynamic> newArticles) {
    for (var article in newArticles) {
      if (!_allArticles.any((a) => a['url'] == article['url'])) {
        // Avoid duplicates by checking the unique 'url' field
        _allArticles.add(article);
      }
    }
  }
}
