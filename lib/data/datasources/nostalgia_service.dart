import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/params/update_nostalgia.dart';
import 'package:wehere_client/data/datasources/api.dart';
import 'package:wehere_client/data/models/nostalgia_model.dart';
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

  Future<NostalgiaModel> get(GetNostalgiaDetailParams params) async {
    final queryParameters = {
      'latitude': params.latitude,
      'longitude': params.longitude
    };
    final dio = Api().dio;
    final response = await dio.get('$_endpoint/${params.nostalgiaId}',
        queryParameters: queryParameters);
    return NostalgiaModel.fromJson(response.data);
  }

  Future<StatisticSummaryModel> getStatisticSummary(String memberId) async {
    final dio = Api().dio;
    final response = await dio.get('$_endpoint/statistics/$memberId');
    return StatisticSummaryModel.fromJson(response.data);
  }

  Future<String> create(CreateNostalgiaParams params) async {
    final dio = Api().dio;
    final requestBody = {
      'title': params.title,
      'description': params.description,
      'visibility': params.visibility.name.toUpperCase(),
      'latitude': params.latitude,
      'longitude': params.longitude,
      'images': params.images
    };
    dio.options.contentType = 'application/json';
    final response = await dio.post(_endpoint, data: requestBody);
    return response.data['id'];
  }

  Future<void> update(UpdateNostalgiaParams params) async {
    final dio = Api().dio;
    final requestBody = {
      'title': params.title,
      'description': params.description,
      'visibility': params.visibility?.name.toUpperCase(),
      'images': params.images
    };
    dio.options.contentType = 'application/json';
    await dio.patch('$_endpoint/${params.id}', data: requestBody);
  }

  Future<void> delete(String nostalgiaId) async {
    final dio = Api().dio;
    await dio.delete('$_endpoint/$nostalgiaId');
  }
}
