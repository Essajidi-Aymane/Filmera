import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TmdbApi{
  final String _baseUrl = 'https://api.themoviedb.org/3';
  late String _apiKey ;

  TmdbApi(){
    _apiKey = dotenv.env['TMDB_API_KEY']!;
  }
  Future<List<dynamic>> getTrending() async {
     final url =
        '$_baseUrl/trending/all/day?api_key=$_apiKey&language=fr-FR';
        final res = await http.get(Uri.parse(url));
     if ( res.statusCode != 200) {
      throw Exception('Failed to load trending data');
     }
     return jsonDecode(res.body)['results'] as List<dynamic>;
  }

  Future<List<dynamic>> search( String query ) async{ 
  final url =
        '$_baseUrl/search/multi?api_key=$_apiKey&language=fr-FR&query=$query';
        final res = await http.get(Uri.parse(url));
        if ( res.statusCode != 200) { throw Exception('Failed to load search data'); }
        
        return jsonDecode(res.body)['results'] as List<dynamic>;

  }
  Future<Map<String, dynamic>> getDetails(int id , bool isMovie) async{
    final type = isMovie ? 'movie' : 'tv';
    final url = '$_baseUrl/$type/$id?api_key=$_apiKey&language=fr-FR';
        final res = await http.get(Uri.parse(url));
        if ( res.statusCode != 200) { throw Exception('Failed to load details data'); }
        
        return jsonDecode(res.body) as Map<String, dynamic>;
  }
}