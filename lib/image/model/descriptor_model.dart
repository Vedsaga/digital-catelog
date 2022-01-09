class Descriptor {
  String? imageURL;
  String? name;
  String? shortDescription;
  String? longDescription;
  String? id;
  String? price;

  Descriptor({
    this.imageURL,
    this.name,
    this.shortDescription,
    this.longDescription,
    this.id,
    this.price,
  });

  Descriptor copyWith({
    String? imageURL,
    String? name,
    String? shortDescription,
    String? longDescription,
    String? id,
    String? price,
  }) {
    return Descriptor(
      imageURL: imageURL ?? this.imageURL,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      id: id ?? this.id,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL,
      'name': name,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'id': id,
      'price': price,
    };
  }

  factory Descriptor.fromMap(Map<String, dynamic> map) {
    return Descriptor(
      imageURL: map['images'][0],
      name: map['name'],
      shortDescription: map['short_desc'],
      longDescription: map['long_desc'],
      id: map['id'],
      price: map['listed_value'],
    );
  }
}
