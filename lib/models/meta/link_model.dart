class Links {
  dynamic next;

  Links({this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'next': next,
    };
  }
}