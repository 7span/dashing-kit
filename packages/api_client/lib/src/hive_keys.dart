enum HiveKeys {
  userToken('token'),
  userRefreshToken('refreshToken');

  const HiveKeys(this.value);

  final String value;
}
