import 'package:json_annotation/json_annotation.dart';

part 'asr.g.dart';

@JsonSerializable()
class AuthorizationSigningRequest {
  @JsonKey(name: 'data:o')
  final DataO dataO;
  @JsonKey(name: 'type:s')
  final String typeS;

  AuthorizationSigningRequest({
    this.dataO,
    this.typeS,
  });

  factory AuthorizationSigningRequest.fromJson(Map<String, dynamic> json) {
    return _$AuthorizationSigningRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AuthorizationSigningRequestToJson(this);
  }
}

@JsonSerializable()
class DataO {
  @JsonKey(name: 'applicationDescription:s')
  final String applicationDescriptionS;
  @JsonKey(name: 'applicationName:s')
  final String applicationNameS;
  @JsonKey(name: 'applicationUrl:s')
  final String applicationUrlS;
  @JsonKey(name: 'actions:as')
  final List<String> actionsAs;
  @JsonKey(name: 'resources:as')
  final List<String> resourcesAs;
  @JsonKey(name: 'subject:s')
  final String subjectS;

  DataO({
    this.applicationDescriptionS,
    this.applicationNameS,
    this.applicationUrlS,
    this.actionsAs,
    this.resourcesAs,
    this.subjectS,
  });

  factory DataO.fromJson(Map<String, dynamic> json) {
    return _$DataOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataOToJson(this);
  }
}

@JsonSerializable()
class PolicyO {
  @JsonKey(name: 'actions:as')
  final List<String> actionsAs;
  @JsonKey(name: 'effect:s')
  final String effectS;
  @JsonKey(name: 'resources:as')
  final List<String> resourcesAs;
  @JsonKey(name: 'subjects:as')
  final List<String> subjectsAs;

  PolicyO({
    this.actionsAs,
    this.effectS,
    this.resourcesAs,
    this.subjectsAs,
  });

  factory PolicyO.fromJson(Map<String, dynamic> json) {
    return _$PolicyOFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PolicyOToJson(this);
  }
}
