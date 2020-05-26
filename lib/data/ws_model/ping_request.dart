import 'package:mochi/data/ws_model/base_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ping_request.g.dart';

@JsonSerializable()
class PingRequest extends BaseRequest {
  @JsonKey(name: '_action')
  String action;

  PingRequest({this.action = "ping"}) : super();

  factory PingRequest.fromJson(Map<String, dynamic> json) =>
      _$PingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PingRequestToJson(this);
}
