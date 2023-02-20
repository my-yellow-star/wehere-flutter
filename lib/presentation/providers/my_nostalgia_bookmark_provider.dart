import 'package:wehere_client/core/params/get_bookmark.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/usecases/get_bookmark.usecase.dart';
import 'package:wehere_client/domain/usecases/get_other_bookmarks_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class MyNostalgiaBookmarkProvider extends ApiProvider {
  final GetBookmarkUseCase _getBookmarkUseCase;
  final GetOtherBookmarksUseCase _getOtherBookmarksUseCase;
  List<NostalgiaSummary> items = [];
  final int _size = 10;
  int _page = 0;
  bool _end = false;
  int total = 0;
  String? _memberId;
  Location _location = Location(0, 0);

  MyNostalgiaBookmarkProvider(
      this._getBookmarkUseCase, this._getOtherBookmarksUseCase);

  @override
  void initialize() {
    isLoading = false;
    error = null;
    _end = false;
    _page = 0;
    total = 0;
    _memberId = null;
    _location = Location(0, 0);
    items = [];
  }

  void initializeMemberId(String value) {
    _memberId = value;
  }

  void initializeLocation(Location value) {
    _location = value;
  }

  Future<void> loadList() async {
    if (_end || isLoading) return;

    late Pagination<NostalgiaSummary> response;
    isLoading = true;
    if (_memberId != null) {
      response = await _getOtherBookmarksUseCase(GetBookmarkParams(
        page: _page,
        size: _size,
        latitude: _location.latitude,
        longitude: _location.longitude,
        memberId: _memberId,
      ));
    } else {
      response = await _getBookmarkUseCase(GetBookmarkParams(
        page: _page,
        size: _size,
        latitude: _location.latitude,
        longitude: _location.longitude,
      ));
    }
    items = [...items, ...response.items];
    total = response.total;
    isLoading = false;
    if (response.nextPage != null) {
      _page = response.nextPage!;
    }
    _end = response.end;
    isLoading = false;
    notifyListeners();
  }
}
