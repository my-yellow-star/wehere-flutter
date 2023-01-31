import 'package:dio/dio.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/file_uploader.dart';
import 'package:wehere_client/domain/repositories/file_repository.dart';

class FileRepositoryImpl extends FileRepository {
  final FileUploader _uploader = FileUploader();

  @override
  Future<List<DataState<String>>> uploadFiles(List<MultipartFile> files) async {
    final List<DataState<String>> responses = [];
    for (var file in files) {
      try {
        final response = await _uploader.upload(file);
        responses.add(DataSuccess(response));
      } on DioError catch (error) {
        responses.add(DataFailed(error));
      }
    }

    return responses;
  }
}
