import 'package:json_annotation/json_annotation.dart';

part 'profileModel.g.dart';

@JsonSerializable()
class ProfileModel {
  String name;
  String username;
  String profession;
  String DOB;
  String address;
  String status;
  ProfileModel(
      {this.DOB,
      this.address,
      this.name,
      this.profession,
      this.status,
      this.username});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
