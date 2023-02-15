import 'package:wehere_client/core/params/blacklist.dart';
import 'package:wehere_client/core/params/report.dart';
import 'package:wehere_client/data/datasources/api.dart';

class ReportService {
  static const _reportEndpoint = '/api/report';
  static const _blacklistEndpoint = '/api/blacklists';

  ReportService._();

  static final _singleton = ReportService._();

  factory ReportService() => _singleton;

  Future<void> report(ReportParams params) async {
    final requestBody = {
      'memberId': params.memberId,
      'nostalgiaId': params.nostalgiaId,
      'reason': params.reason
    };
    final dio = Api().dio;
    dio.options.contentType = 'application/json';
    await dio.post(_reportEndpoint, data: requestBody);
  }

  Future<void> createBlacklist(BlacklistParams params) async {
    final requestBody = {
      'memberId': params.memberId,
      'nostalgiaId': params.nostalgiaId
    };
    final dio = Api().dio;
    dio.options.contentType = 'application/json';
    await dio.post(_blacklistEndpoint, data: requestBody);
  }

  Future<void> deleteBlacklist(BlacklistParams params) async {
    final requestBody = {
      'memberId': params.memberId,
      'nostalgiaId': params.nostalgiaId
    };
    final dio = Api().dio;
    dio.options.contentType = 'application/json';
    await dio.delete(_blacklistEndpoint, data: requestBody);
  }
}
