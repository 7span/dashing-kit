class ForceUpdateConfig {
  ForceUpdateConfig({
    required this.version,
    required this.allowCancel,
  });

  factory ForceUpdateConfig.fromJson(Map<String, dynamic> json) {
    return ForceUpdateConfig(
      version: json['version'] as String,
      allowCancel: json['allow_cancel'] as bool,
    );
  }

  final String version;
  final bool allowCancel;
}
