class License {
  int? licenseId;
  int? provinceId;
  String? licenseName;

  License({this.licenseId, this.provinceId, this.licenseName});

  Map<String,dynamic> toMap() => {
    'provinceId':provinceId,
    'licenseName':licenseName
  };
}