import 'package:wehere_client/core/params/search_location.dart';
import 'package:wehere_client/data/datasources/search_service.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';
import 'package:wehere_client/domain/repositories/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchService _searchService = SearchService();

  @override
  Future<Pagination<SearchedLocation>> searchLocation(
      SearchLocationParams params) async {
    return await _searchService.searchLocation(params);
  }
}
