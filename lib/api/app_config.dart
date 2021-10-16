import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


enum EnvType {
  dev,
  prod,
}

/// Environment declare here
class Env {
  Env._({
    required this.envType,
    required this.apiBaseUrl,
  });

  /// Dev mode
  factory Env.dev() {
    return Env._(
      envType: EnvType.dev,
      apiBaseUrl: 'https://nhancv.free.beeceptor.com',
    );
  }

  final EnvType envType;
  final String apiBaseUrl;
}

/// Config env
class AppConfig {
  factory AppConfig({Env? env}) {
    if (env != null) {
      I.env = env;
    }

    return I;
  }

  AppConfig._private();

  static final AppConfig I = AppConfig._private();

  Env env = Env.dev();

}
