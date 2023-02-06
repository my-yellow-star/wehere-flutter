import 'package:wehere_client/core/params/update_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class UpdateNostalgiaUseCase
    extends UseCase<DataState<String>, UpdateNostalgiaParams> {
  final NostalgiaRepository _nostalgiaRepository;

  UpdateNostalgiaUseCase(this._nostalgiaRepository);

  @override
  Future<DataState<String>> call(UpdateNostalgiaParams params) async {
    return await _nostalgiaRepository.update(params);
  }
}
