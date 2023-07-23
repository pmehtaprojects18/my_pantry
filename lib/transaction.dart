class InventoryTransaction {
  final int id;
  final String transactionDate;
  final int productId;
  final int qty;
  final String transactionType;

  InventoryTransaction({required this.id, required this.transactionDate, required this.productId, required this.qty, required this.transactionType});

  factory InventoryTransaction.fromJson(Map<String, dynamic> json){
    return InventoryTransaction(
      id: json['id'],
      transactionDate: json['transactionDate'],
      productId: json['productId'],
      qty: json['qty'],
      transactionType: json['transactionType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionDate': transactionDate,
    'productId': productId,
    'qty': qty,
    'transactionType': transactionType,
  };

}