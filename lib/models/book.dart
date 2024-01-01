
class Book {
  int id;
  String name;
  String author;
  // constructor
  Book(this.id, this.author, this.name);
  // convert to map
  Map<String, dynamic> toMap(){
    var data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['author'] = author;
    return data;
  }
  // convert map of book to model of book
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      map['id'],
      map['name'],
      map['author']
    );
  }
}
