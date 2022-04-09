class Item {
  String? CategoryName;
  String? CategoryKey;
  String? item;
  String? itemKey;
  String? weight;
  int? price;
  int? quantity;
  String? status;
  String? subcategoryKey;
  int? yetToPrepare;

  Item(
      {this.CategoryKey,
      this.CategoryName,
      this.item,
      this.itemKey,
      this.price,
      this.quantity,
      this.status,
      this.subcategoryKey,
      this.weight,
      this.yetToPrepare});
}
