import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/data/datasources/api.dart';
import 'package:wehere_client/data/models/nostalgia_summary_model.dart';
import 'package:wehere_client/data/models/pagination_model.dart';
import 'package:wehere_client/data/models/statistic_summary_model.dart';

class NostalgiaService {
  static const _endpoint = '/api/nostalgia';

  NostalgiaService._();

  static final _singleton = NostalgiaService._();

  factory NostalgiaService() => _singleton;

  Future<PaginationModel<NostalgiaSummaryModel>> getList(
      GetNostalgiaParams params) async {
    final queryParameters = {
      'page': params.page,
      'size': params.size,
      'condition': params.condition,
      'latitude': params.latitude,
      'longitude': params.longitude,
      'maxDistance': params.maxDistance
    };
    final dio = Api().dio;
    final response = await dio.get(_endpoint, queryParameters: queryParameters);
    return PaginationModel.fromJson(
        response.data, NostalgiaSummaryModel.fromJson);
  }

  Future<StatisticSummaryModel> getStatisticSummary(String memberId) async {
    final dio = Api().dio;
    final response = await dio.get('$_endpoint/statistics/$memberId');
    return StatisticSummaryModel.fromJson(response.data);
  }
}
