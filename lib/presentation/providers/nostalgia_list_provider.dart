import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_list_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class NostalgiaListProvider extends ApiProvider {
  final GetNostalgiaListUseCase _getNostalgiaListUseCase;
  final int _size = 10;
  int _page = 0;
  bool _end = false;
  int total = 0;
  List<NostalgiaSummary> items = [];
  double? _targetLatitude;
  double? _targetLongitude;

  bool get end => _end;

  NostalgiaListProvider(this._getNostalgiaListUseCase);

  @override
  void initialize() {
    _page = 0;
    _end = false;
    isLoading = true;
    items = [];
    total = 0;
    error = null;
    _targetLatitude = null;
    _targetLongitude = null;
  }

  Future<void> loadList({
    double? maxDistance,
    double? latitude,
    double? longitude,
    int? size,
    String? memberId,
    required NostalgiaCondition condition,
  }) async {
    if (_end) {
      return;
    }
    final params = GetNostalgiaParams(
        page: _page,
        size: size ?? _size,
        memberId: memberId,
        maxDistance: maxDistance,
        condition: condition,
        latitude: latitude,
        longitude: longitude,
        targetLatitude: _targetLatitude,
        targetLongitude: _targetLongitude);
    final response = await _getNostalgiaListUseCase(params);
    items = [...items, ...response.items];
    total = response.total;
    isLoading = false;
    if (response.nextPage != null) {
      _page = response.nextPage!;
    }
    _end = response.end;

    notifyListeners();
  }

  void updateTargetLatitude(double value) {
    _targetLatitude = value;
  }

  void updateTargetLongitude(double value) {
    _targetLongitude = value;
  }
}
