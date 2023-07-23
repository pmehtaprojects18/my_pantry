import 'package:flutter/material.dart';
import 'package:my_pantry/add_transaction.dart';
import 'package:my_pantry/product.dart';

import 'add_product.dart';
import 'db_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Pantry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Product> products = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async{
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProduct()),
              );
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: DbService().getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot){
          if(snapshot.hasData){
            products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text(products[index].description),
                  trailing: Text(products[index].quantity.toString()),
                );
              },
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransaction()),
          );
          setState(() {});
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}
