class Scenic {
  int? scenicId;
  int? provinceId;
  String? scenicName;

  Scenic({this.scenicId, this.provinceId, this.scenicName});

  Map<String,dynamic> toMap() => {
    'provinceId':provinceId,
    'scenicName':scenicName
  };
}