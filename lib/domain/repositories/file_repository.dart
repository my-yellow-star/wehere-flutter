import 'package:dio/dio.dart';
import 'package:wehere_client/core/resources/data_state.dart';

abstract class FileRepository {
  Future<List<DataState<String>>> uploadFiles(List<MultipartFile> files);
}
