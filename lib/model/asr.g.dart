// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorizationSigningRequest _$AuthorizationSigningRequestFromJson(
    Map<String, dynamic> json) {
  return AuthorizationSigningRequest(
    dataO: json['data:o'] == null
        ? null
        : DataO.fromJson(json['data:o'] as Map<String, dynamic>),
    typeS: json['type:s'] as String,
  );
}

Map<String, dynamic> _$AuthorizationSigningRequestToJson(
        AuthorizationSigningRequest instance) =>
    <String, dynamic>{
      'data:o': instance.dataO,
      'type:s': instance.typeS,
    };

DataO _$DataOFromJson(Map<String, dynamic> json) {
  return DataO(
    applicationDescriptionS: json['applicationDescription:s'] as String,
    applicationNameS: json['applicationName:s'] as String,
    applicationUrlS: json['applicationUrl:s'] as String,
    actionsAs: (json['actions:as'] as List)?.map((e) => e as String)?.toList(),
    resourcesAs:
        (json['resources:as'] as List)?.map((e) => e as String)?.toList(),
    subjectS: json['subject:s'] as String,
  );
}

Map<String, dynamic> _$DataOToJson(DataO instance) => <String, dynamic>{
      'applicationDescription:s': instance.applicationDescriptionS,
      'applicationName:s': instance.applicationNameS,
      'applicationUrl:s': instance.applicationUrlS,
      'actions:as': instance.actionsAs,
      'resources:as': instance.resourcesAs,
      'subject:s': instance.subjectS,
    };

PolicyO _$PolicyOFromJson(Map<String, dynamic> json) {
  return PolicyO(
    actionsAs: (json['actions:as'] as List)?.map((e) => e as String)?.toList(),
    effectS: json['effect:s'] as String,
    resourcesAs:
        (json['resources:as'] as List)?.map((e) => e as String)?.toList(),
    subjectsAs:
        (json['subjects:as'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PolicyOToJson(PolicyO instance) => <String, dynamic>{
      'actions:as': instance.actionsAs,
      'effect:s': instance.effectS,
      'resources:as': instance.resourcesAs,
      'subjects:as': instance.subjectsAs,
    };
