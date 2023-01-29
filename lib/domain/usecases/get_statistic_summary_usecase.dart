import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/statistic_summary.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class GetStatisticSummaryUseCase
    extends UseCase<DataState<StatisticSummary>, String> {
  final NostalgiaRepository _nostalgiaRepository;

  GetStatisticSummaryUseCase(this._nostalgiaRepository);

  @override
  Future<DataState<StatisticSummary>> call(String params) async {
    return await _nostalgiaRepository.getStatisticSummary(params);
  }
}
