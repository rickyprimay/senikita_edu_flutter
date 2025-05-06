class Category {
  final int? id;
  final String name;
  final String? slug;
  final String? description;  
  final String? status;       
  final String? thumbnail;    

  Category({
    this.id,
    required this.name,
    this.slug,
    this.description,  
    this.status,       
    this.thumbnail, 
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'], 
      status: json['status'],           
      thumbnail: json['thumbnail'],     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description, 
      'status': status,           
      'thumbnail': thumbnail,     
    };
  }
}
