import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../google_map/place.dart';
import '../google_map/place_list.dart';
import '../google_map/place_search_service.dart';
import '../google_map/google_map_widget.dart';

class MapSearchPage extends StatefulWidget {
  final String? initialKeyword;
  const MapSearchPage({super.key, this.initialKeyword});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  late final PlaceSearchService service;
  final TextEditingController _searchController = TextEditingController();
  List<Place> _places = [];
  Place? _selected;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'] ?? '';
    service = PlaceSearchService(apiKey);

    if (widget.initialKeyword != null && widget.initialKeyword!.trim().isNotEmpty) {
      _searchController.text = widget.initialKeyword!;
      Future.delayed(Duration.zero, () => _search(widget.initialKeyword!));
    }
  }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final places = await service.searchPlaces(keyword);
      setState(() {
        _places = places;
        _selected = places.isNotEmpty ? places[0] : null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _places = [];
        _selected = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSelect(Place place) {
    setState(() => _selected = place);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구글 장소 검색'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _search,
                    decoration: InputDecoration(
                      hintText: '검색어를 입력하세요',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_searchController.text),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          // 결과 & 지도
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: PlaceList(
                    places: _places,
                    onTap: _onSelect,
                    selected: _selected,
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (kIsWeb) {
                        return const Center(
                          child: Text(
                            "웹에서는 구글 지도가 지원되지 않습니다.\n(모바일 앱에서만 지도 제공)",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return GoogleMapWidget(selectedPlace: _selected);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
