class Province {
  /// The unique identifier for the province.
  int? provinceId;

  /// The name of the province.
  String? provinceName;

  Province({this.provinceId, this.provinceName});

  Map<String, dynamic> toMap() => {
    'provinceName': provinceName,
  };
}