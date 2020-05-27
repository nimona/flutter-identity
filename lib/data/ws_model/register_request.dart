import 'package:identity/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  @JsonKey(name: 'privateKeySeed')
  String privateKeySeed;

  RegisterRequest(
      {this.action = "register",
      this.privateKeySeed})
      : super();

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
