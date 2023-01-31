import 'package:dio/dio.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/file_repository.dart';

class UploadFileUseCase
    extends UseCase<List<DataState<String>>, List<MultipartFile>> {
  final FileRepository _fileRepository;

  UploadFileUseCase(this._fileRepository);

  @override
  Future<List<DataState<String>>> call(List<MultipartFile> params) async {
    return await _fileRepository.uploadFiles(params);
  }
}
