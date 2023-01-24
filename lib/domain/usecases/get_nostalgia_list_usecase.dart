import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class GetNostalgiaListUseCase
    extends UseCase<Pagination<NostalgiaSummary>, GetNostalgiaParams> {
  final NostalgiaRepository _nostalgiaRepository;

  GetNostalgiaListUseCase(this._nostalgiaRepository);

  @override
  Future<Pagination<NostalgiaSummary>> call(GetNostalgiaParams params) async {
    return await _nostalgiaRepository.getList(params);
  }
}
