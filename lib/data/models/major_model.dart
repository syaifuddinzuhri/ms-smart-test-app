class Major {
  final String id;
  final String name;
  final String code;

  Major({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}