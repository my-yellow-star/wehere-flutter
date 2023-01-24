import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static final _singleton = StorageService._();

  factory StorageService() => _singleton;

  Future<String?> getString(String key) async {
    final pfi = await SharedPreferences.getInstance();
    return pfi.getString(key);
  }

  Future<void> setString(String key, String? value) async {
    final pfi = await SharedPreferences.getInstance();
    if (value == null) {
      pfi.remove(key);
    } else {
      pfi.setString(key, value);
    }
  }

  Future<String?> getAccessToken() async => await getString('accessToken');

  Future<void> setAccessToken(String value) async =>
      await setString('accessToken', value);

  Future<void> deleteAccessToken() async =>
      await setString('accessToken', null);

  Future<String?> getRefreshToken() async => await getString('refreshToken');

  Future<void> setRefreshToken(String value) async =>
      await setString('refreshToken', value);

  Future<void> deleteRefreshToken() async =>
      await setString('refreshToken', null);
}
