import 'package:wehere_client/core/params/blacklist.dart';
import 'package:wehere_client/core/params/report.dart';
import 'package:wehere_client/core/resources/data_state.dart';

abstract class ReportRepository {
  Future<DataState> report(ReportParams params);

  Future<DataState> createBlacklist(BlacklistParams params);

  Future<DataState> deleteBlacklist(BlacklistParams params);
}
