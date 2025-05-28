import 'dart:convert';
import 'package:http/http.dart' as http;
import 'place.dart';

class PlaceSearchService {
  final String apiKey;
  PlaceSearchService(this.apiKey);

  Future<List<Place>> searchPlaces(String keyword) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(keyword)}&key=$apiKey&language=ko';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Place.fromJson(json)).toList();
    } else {
      throw Exception('구글 장소 검색 실패: ${response.body}');
    }
  }
}
