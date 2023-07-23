import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_pantry/db_service.dart';
import 'package:my_pantry/product.dart';
import 'package:my_pantry/transaction.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController transactionDateController =
      TextEditingController(text: "");
  TextEditingController productController = TextEditingController(text: "");
  TextEditingController quantityController = TextEditingController(text: "");
  String transactionType = "Buy";
  final List<bool> selectedType = [true, false];
  List<Product> _products = [];
  Product selectedProduct = Product(
      name: "None",
      description: "None",
      quantity: 0,
      id: DateTime.now().millisecondsSinceEpoch);

  var formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactionDateController.text = formatter.format(DateTime.now());
    getProducts();
  }

  //get all products
  Future<void> getProducts() async {
    _products = await DbService().getProducts();
  }

  // open datetime picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // current date
      firstDate: DateTime(2015), // start date
      lastDate: DateTime(2050), // end date
    );
    if (picked != null) {
      setState(() {
        transactionDateController.text = formatter.format(picked);
      });
    }
  }

  // add inventoryTransaction
  Future<void> addTransaction() async {
    InventoryTransaction transaction = InventoryTransaction(
        transactionDate: transactionDateController.text,
        productId: selectedProduct.id,
        qty: int.parse(quantityController.text),
        transactionType: transactionType,
        id: DateTime.now().millisecondsSinceEpoch);
    DbService().insertTransaction(transaction).whenComplete(() => {
          if (transactionType == "Buy")
            {
              DbService().updateProductQuantity(
                  selectedProduct.id, int.parse(quantityController.text))
            }
          else
            {
              DbService().updateProductQuantity(
                  selectedProduct.id, -int.parse(quantityController.text))
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: transactionDateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Transaction Date',
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
            const SizedBox(height: 20),
            Autocomplete<Product>(
              initialValue: const TextEditingValue(text: ''),
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                productController = fieldTextEditingController;
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onEditingComplete: onFieldSubmitted,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Product',
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<Product>.empty();
                }
                return _products.where((Product option) {
                  return option.name.toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Product option) => option.name,
              onSelected: (Product selection) {
                selectedProduct = selection;
              },
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
            ToggleButtons(
              isSelected: selectedType,
              onPressed: (int index) {
                setState(() {
                  selectedType[0] = index == 0;
                  selectedType[1] = index == 1;
                  if (index == 0) {
                    transactionType = "Buy";
                  } else {
                    transactionType = "Use";
                  }
                });
              },
              children: const [Text("Buy"), Text("Use")],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addTransaction().whenComplete(() => Navigator.pop(context));
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
