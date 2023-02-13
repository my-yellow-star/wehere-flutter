import 'package:wehere_client/core/params/search_location.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';
import 'package:wehere_client/domain/usecases/search_location_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class SearchLocationProvider extends ApiProvider {
  final SearchLocationUseCase _searchLocationUseCase;

  List<SearchedLocation> items = [];
  int _page = 1;
  bool _end = false;
  String _keyword = "";
  Location? _location;

  SearchLocationCountry _country = SearchLocationCountry.korea;

  SearchLocationProvider(this._searchLocationUseCase);

  @override
  void initialize() {
    _page = 1;
    items = [];
    _end = false;
    isLoading = false;
  }

  Future<void> loadList() async {
    if (_end || isLoading) return;

    isLoading = true;
    final response = await _searchLocationUseCase(SearchLocationParams(
        keyword: _keyword,
        page: _page,
        country: _country,
        latitude: _location!.latitude,
        longitude: _location!.longitude));
    items.addAll(response.items);
    _end = response.end;
    _page = response.nextPage ?? 0;
    isLoading = false;
    notifyListeners();
  }

  void registerLocation(Location location) {
    _location = location;
  }

  void updateKeyword(String keyword) {
    _keyword = keyword;
    initialize();

    loadList();
  }

  void updateCountry(SearchLocationCountry country) {
    _country = country;
    notifyListeners();
  }
}
