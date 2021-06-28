class User {
  User({
    this.image,
    this.status,
    this.email,
    this.name,
    this.id,
  });

  String image;
  String status;
  String email;
  String name;
  String id;

  factory User.fromJson(Map<String, dynamic> json) => User(
        image: json["image"],
        status: json["status"],
        email: json["email"],
        name: json["name"],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "status": status,
        "email": email,
        "name": name,
        'id' : id,
      };
}
