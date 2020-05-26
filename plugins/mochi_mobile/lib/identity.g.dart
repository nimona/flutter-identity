// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Identity _$IdentityFromJson(Map<String, dynamic> json) {
  return Identity(
    privateKey: json['privateKey'] as String,
    privateKeyMnemonic: json['privateKeyMnemonic'] as String,
    publicKey: json['publicKey'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
      'privateKey': instance.privateKey,
      'privateKeyMnemonic': instance.privateKeyMnemonic,
      'publicKey': instance.publicKey,
      'name': instance.name,
    };
