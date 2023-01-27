import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_list_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class NostalgiaListProvider extends ApiProvider {
  final GetNostalgiaListUseCase _getNostalgiaListUseCase;
  final int _size = 10;
  int _page = 0;
  bool _end = false;
  List<NostalgiaSummary> items = [];

  bool get end => _end;

  NostalgiaListProvider(this._getNostalgiaListUseCase);

  void initialize() {
    _page = 0;
    _end = false;
    isLoading = true;
    items = [];
  }

  Future<void> loadList({
    int? maxDistance,
    double? latitude,
    double? longitude,
    required NostalgiaCondition condition,
  }) async {
    if (_end) {
      return;
    }
    final params = GetNostalgiaParams(
        page: _page,
        size: _size,
        condition: condition,
        latitude: latitude,
        longitude: longitude);
    final response = await _getNostalgiaListUseCase(params);
    items = [...items, ...response.items];
    isLoading = false;
    if (response.nextPage != null) {
      _page = response.nextPage!;
    }
    _end = response.end;

    notifyListeners();
  }
}
