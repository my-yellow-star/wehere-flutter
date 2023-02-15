import 'package:wehere_client/core/params/blacklist.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/report_repository.dart';

class CreateBlacklistUseCase extends UseCase<DataState, BlacklistParams> {
  final ReportRepository _reportRepository;

  CreateBlacklistUseCase(this._reportRepository);

  @override
  Future<DataState> call(BlacklistParams params) async {
    return await _reportRepository.createBlacklist(params);
  }
}
