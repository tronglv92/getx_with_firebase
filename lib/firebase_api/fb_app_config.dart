


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
class FirebaseAppConfig {
  factory FirebaseAppConfig({Env? env}) {
    if (env != null) {
      I.env = env;
    }

    return I;
  }

  FirebaseAppConfig._private();

  static final FirebaseAppConfig I = FirebaseAppConfig._private();

  Env env = Env.dev();

}
