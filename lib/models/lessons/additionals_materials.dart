class AdditionalMaterial {
  final int id;
  final String title;
  final String filePath;

  AdditionalMaterial({
    required this.id,
    required this.title,
    required this.filePath,
  });

  factory AdditionalMaterial.fromJson(Map<String, dynamic> json) {
    return AdditionalMaterial(
      id: json['id'] as int,
      title: json['title'] as String,
      filePath: json['file_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_path': filePath,
    };
  }
}

extension AdditionalMaterialExtension on AdditionalMaterial {
  String get titleWithExtension {
    final uri = Uri.parse(filePath);
    final pathSegments = uri.pathSegments;
    final fileName = pathSegments.isNotEmpty ? pathSegments.last : '';

    final extension = fileName.contains('.') ? '.${fileName.split('.').last}' : '';

    return '$title$extension';
  }
}
