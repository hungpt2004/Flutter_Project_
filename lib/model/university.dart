class University {
  int? universityId;
  int? provinceId;
  String? universityName;

  University({this.universityId, this.provinceId, this.universityName});

  Map<String,dynamic> toMap() => {
    'provinceId':provinceId,
    'universityName':universityName
  };
}