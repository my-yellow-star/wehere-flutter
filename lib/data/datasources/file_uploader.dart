import 'package:dio/dio.dart';
import 'package:wehere_client/data/datasources/api.dart';

class FileUploader {
  static const _endpoint = '/api/files';

  FileUploader._();

  static final _singleton = FileUploader._();

  factory FileUploader() => _singleton;

  Future<String> upload(MultipartFile file) async {
    final dio = Api().dio;
    FormData data = FormData.fromMap({'file': file});
    dio.options.contentType = 'multipart/form-data';
    final response = await dio.post(_endpoint, data: data);
    return response.data['url'];
  }
}
