import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/statistic_summary.dart';
import 'package:wehere_client/domain/usecases/get_statistic_summary_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class StatisticProvider extends ApiProvider {
  final GetStatisticSummaryUseCase _getStatisticSummaryUseCase;
  StatisticSummary? summary;

  StatisticProvider(this._getStatisticSummaryUseCase);

  @override
  void initialize() {
    summary = null;
    isLoading = true;
    error = null;
  }

  Future<void> getSummary(String memberId) async {
    final response = await _getStatisticSummaryUseCase(memberId);
    if (response is DataSuccess) {
      summary = response.data;
    } else {
      error = response.error;
    }
    isLoading = false;
    notifyListeners();
  }
}
