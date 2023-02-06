import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class DeleteNostalgiaUseCase extends UseCase<DataState<dynamic>, String> {
  final NostalgiaRepository _nostalgiaRepository;

  DeleteNostalgiaUseCase(this._nostalgiaRepository);

  @override
  Future<DataState> call(String params) async {
    return await _nostalgiaRepository.delete(params);
  }
}
