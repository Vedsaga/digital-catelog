class Descriptor {
  String? imageURL;
  String? name;
  String? shortDescription;
  String? longDescription;
  String? id;

  Descriptor({
    this.imageURL,
    this.name,
    this.shortDescription,
    this.longDescription,
    this.id,
  });

  Descriptor copyWith({
    String? imageURL,
    String? name,
    String? shortDescription,
    String? longDescription,
    String? id,
  }) {
    return Descriptor(
      imageURL: imageURL ?? this.imageURL,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageURL': imageURL,
      'name': name,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'id': id,
    };
  }

  factory Descriptor.fromMap(Map<String, dynamic> map) {
    return Descriptor(
      //  map['image'] is '[https://mandi.succinct.in/attachments/view/17592186044546.png]'
      imageURL: map['images'][0],
      name: map['name'],
      shortDescription: map['short_desc'],
      longDescription: map['long_desc'],
      id: map['id'],
    );
  }
}
