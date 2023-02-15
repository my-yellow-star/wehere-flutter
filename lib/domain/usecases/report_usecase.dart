import 'package:wehere_client/core/params/report.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/report_repository.dart';

class ReportUseCase extends UseCase<DataState, ReportParams> {
  final ReportRepository _reportRepository;

  ReportUseCase(this._reportRepository);

  @override
  Future<DataState> call(ReportParams params) async {
    return await _reportRepository.report(params);
  }
}
