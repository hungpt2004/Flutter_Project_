class City {
  int? cityId;
  int? provinceId;
  String? cityName;

  City({this.cityId, this.provinceId, this.cityName});

  Map<String,dynamic> toMap() => {
    'provinceId':provinceId,
    'cityName':cityName
  };

}