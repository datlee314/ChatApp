// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FriendsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsModel _$FriendsModelFromJson(Map<String, dynamic> json) {
  return FriendsModel(
    friendname: json['DOB'] as String,
    time: json['address'] as String,
    name: json['name'] as String,
    id: json['profession'] as String,
  );
}

Map<String, dynamic> _$FriendsModelToJson(FriendsModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.friendname,
      'profession': instance.time,
      'DOB': instance.id,
    };
