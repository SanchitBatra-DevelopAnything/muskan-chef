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
  int yetToPrepare;
  String? cakeFlavour;
  String? designCategory;

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
      this.cakeFlavour,
      this.designCategory,
      this.yetToPrepare = 0});
}
