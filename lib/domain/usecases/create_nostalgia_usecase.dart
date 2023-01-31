import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class CreateNostalgiaUseCase
    extends UseCase<DataState<String>, CreateNostalgiaParams> {
  final NostalgiaRepository _nostalgiaRepository;

  CreateNostalgiaUseCase(this._nostalgiaRepository);

  @override
  Future<DataState<String>> call(CreateNostalgiaParams params) async {
    return _nostalgiaRepository.create(params);
  }
}
