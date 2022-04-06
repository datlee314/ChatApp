import 'package:json_annotation/json_annotation.dart';

part 'friendsModel.g.dart';

@JsonSerializable()
class FriendsModel {
  String name;
  String friendname;
  String time;
  String id;
  FriendsModel({
    this.friendname,
    this.time,
    this.name,
    this.id,
  });

  factory FriendsModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendsModelToJson(this);
}
