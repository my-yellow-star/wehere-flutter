import 'package:wehere_client/core/params/search_location.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';
import 'package:wehere_client/domain/repositories/search_repository.dart';

class SearchLocationUseCase
    extends UseCase<Pagination<SearchedLocation>, SearchLocationParams> {
  final SearchRepository _searchRepository;

  SearchLocationUseCase(this._searchRepository);

  @override
  Future<Pagination<SearchedLocation>> call(SearchLocationParams params) async {
    return await _searchRepository.searchLocation(params);
  }
}
