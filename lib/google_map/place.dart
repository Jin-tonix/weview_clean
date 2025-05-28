class Place {
  final String name;
  final String address;
  final double lat;
  final double lng;

  Place({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json['geometry']['location'];
    return Place(
      name: json['name'],
      address: json['formatted_address'] ?? '',
      lat: location['lat'],
      lng: location['lng'],
    );
  }
}
