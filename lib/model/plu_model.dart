class PLUsEntity{
  final int isDeleted;
  final String id;
  final String plu;
  final String sku;
  final int numberSplit;

  PLUsEntity({this.isDeleted, this.id, this.plu, this.sku, this.numberSplit});

  factory PLUsEntity.fromJson(Map<String, dynamic> json) {
    return PLUsEntity(
      isDeleted: json['IsDeleted'],
      id: json['_id'],
      plu: json['PLU'],
      sku: json['SKU'],
      numberSplit: json['NumberSplit'],
    );
  }
}