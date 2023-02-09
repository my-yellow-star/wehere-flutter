import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';

class MyNostalgiaGridProvider extends NostalgiaListProvider {
  MyNostalgiaGridProvider(super.getNostalgiaListUseCase);

  @override
  Future<void> loadList(
      {double? maxDistance,
      double? latitude,
      double? longitude,
      int? size,
      String? memberId,
      NostalgiaCondition condition = NostalgiaCondition.member}) {
    return super.loadList(
        maxDistance: maxDistance,
        latitude: latitude,
        longitude: longitude,
        size: size,
        memberId: memberId,
        condition: condition);
  }
}
