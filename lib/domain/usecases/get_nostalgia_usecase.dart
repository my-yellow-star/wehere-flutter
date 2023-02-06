import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class GetNostalgiaUseCase
    extends UseCase<DataState<Nostalgia>, GetNostalgiaDetailParams> {
  final NostalgiaRepository _nostalgiaRepository;

  GetNostalgiaUseCase(this._nostalgiaRepository);

  @override
  Future<DataState<Nostalgia>> call(GetNostalgiaDetailParams params) async {
    return await _nostalgiaRepository.get(params);
  }
}
