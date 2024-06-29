class Speciality {
  int? specialityId;
  int? provinceId;
  String? specialityName;

  Speciality({this.specialityId, this.provinceId,this.specialityName});

  Map<String, dynamic> toMap() {
    return {
      'provinceId': provinceId,
      'specialityName': specialityName,
    };
  }
}