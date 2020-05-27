import 'package:json_annotation/json_annotation.dart';

part 'identity.g.dart';

@JsonSerializable()
class Identity {
  final String privateKey;
  final String privateKeyMnemonic;
  final String publicKey;
  final String name;

  Identity({
    this.privateKey,
    this.privateKeyMnemonic,
    this.publicKey,
    this.name,
  });
  
  factory Identity.fromJson(Map<String, dynamic> json) {
    return _$IdentityFromJson(json);
  }
  
  Map<String, dynamic> toJson() {
    return _$IdentityToJson(this);
  }
}