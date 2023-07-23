class Product{
  int id;
  String name;
  String description;
  int quantity;


  Product({required this.id, required this.name, required this.description, required this.quantity});

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'quantity': quantity,
  };
}