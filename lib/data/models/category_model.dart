class Category {
  final int? id;
  final String name;
  final String? color;
  final String? icon;
  final String createdAt;

  Category({
    this.id,
    required this.name,
    this.color,
    this.icon,
    required this.createdAt,
  });

  Category copyWith({
    int? id,
    String? name,
    String? color,
    String? icon,
    String? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'color': color,
    'icon': icon,
    'created_at': createdAt,
  };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'],
    name: map['name'],
    color: map['color'],
    icon: map['icon'],
    createdAt: map['created_at'],
  );
}
