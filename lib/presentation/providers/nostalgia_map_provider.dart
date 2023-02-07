import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';

class NostalgiaMapProvider extends NostalgiaListProvider {
  NostalgiaMapProvider(super.getNostalgiaListUseCase);

  @override
  Future<void> loadList(
      {double? maxDistance,
      double? latitude,
      double? longitude,
      int? size,
      NostalgiaCondition condition = NostalgiaCondition.around}) {
    return super.loadList(
        maxDistance: maxDistance,
        latitude: latitude,
        longitude: longitude,
        size: size,
        condition: condition);
  }
}
