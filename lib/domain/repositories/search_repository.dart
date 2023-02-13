import 'package:wehere_client/core/params/search_location.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';

abstract class SearchRepository {
  Future<Pagination<SearchedLocation>> searchLocation(
      SearchLocationParams params);
}
