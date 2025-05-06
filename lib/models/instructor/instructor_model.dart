class Instructor {
  int id;
  String name;
  String? photo;
  String? expertise;

  Instructor({
    required this.id,
    required this.name,
    this.photo,
    this.expertise,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      expertise: json['expertise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'expertise': expertise,
    };
  }
}