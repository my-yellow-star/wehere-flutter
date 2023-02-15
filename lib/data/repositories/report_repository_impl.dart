import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/blacklist.dart';
import 'package:wehere_client/core/params/report.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/report_service.dart';
import 'package:wehere_client/domain/repositories/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportService _reportService = ReportService();

  @override
  Future<DataState> createBlacklist(BlacklistParams params) async {
    try {
      await _reportService.createBlacklist(params);
      return DataSuccess(null);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

  @override
  Future<DataState> deleteBlacklist(BlacklistParams params) async {
    try {
      await _reportService.deleteBlacklist(params);
      return DataSuccess(null);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

  @override
  Future<DataState> report(ReportParams params) async {
    try {
      await _reportService.report(params);
      return DataSuccess(null);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }
}
