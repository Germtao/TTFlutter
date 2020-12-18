import 'package:json_annotation/json_annotation.dart';

part 'env_config.g.dart';

@JsonSerializable(createToJson: false)
class EnvConfig {
  final String env;
  final bool debug;

  EnvConfig({
    this.env,
    this.debug,
  });

  /// 反序列化
  factory EnvConfig.fromJson(Map<String, dynamic> json) => _$EnvConfigFromJson(json);
}
