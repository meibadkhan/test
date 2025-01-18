class Person {
  int? id;
  String? name;
  String? address;

  Person({this.id, this.name, this.address});

  // Convert a Person object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  // Create a Person object from JSON
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
    );
  }
}
