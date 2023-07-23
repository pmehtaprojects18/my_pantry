import 'package:flutter/material.dart';
import 'package:my_pantry/product.dart';

import 'db_service.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController quantityController = TextEditingController(text: "");

  Future<void> addProduct() async{
    Product product = Product(
      name: nameController.text,
      description: descriptionController.text,
      quantity: int.parse(quantityController.text), id: DateTime.now().millisecondsSinceEpoch
    );
    await DbService().insertProduct(product);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Product Name',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addProduct().whenComplete(() => Navigator.pop(context));
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      )
    );
  }
}
