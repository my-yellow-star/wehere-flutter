import 'package:wehere_client/core/params/search_location.dart';
import 'package:wehere_client/data/models/pagination_model.dart';
import 'package:wehere_client/data/models/searched_location_model.dart';

import 'api.dart';

class SearchService {
  static const _endpoint = '/api/search';

  SearchService._();

  static final singleton = SearchService._();

  factory SearchService() => singleton;

  Future<PaginationModel<SearchedLocationModel>> searchLocation(
      SearchLocationParams params) async {
    final queryParameters = {
      'page': params.page,
      'keyword': params.keyword,
      'country': params.country.name.toUpperCase(),
      'latitude': params.latitude,
      'longitude': params.longitude
    };
    final dio = Api().dio;
    final response =
        await dio.get('$_endpoint/locations', queryParameters: queryParameters);
    return PaginationModel.fromJson(
        response.data, SearchedLocationModel.fromJson);
  }
}
