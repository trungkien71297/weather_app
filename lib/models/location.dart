class Location {
  int? id;
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? url;
  String? tzId;
  int? localtimeEpoch;
  String? localTime;
  Location(
      {this.id,
      this.name,
      this.region,
      this.country,
      this.lat,
      this.lon,
      this.url,
      this.tzId,
      this.localTime,
      this.localtimeEpoch});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['id'],
        name: json['name'],
        region: json['region'],
        country: json['country'],
        lat: json['lat'],
        lon: json['lon'],
        url: json['url'],
        localTime: json['localtime'],
        localtimeEpoch: json['localtime_epoch'],
        tzId: json['tz_id']);
  }
}
