import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/usecases/get_place_location_usecase.dart';
import 'package:wehere_client/injector.dart';

class LocationManager {
  final GetPlaceLocationUseCase _getPlaceLocationUseCase =
      injector.get<GetPlaceLocationUseCase>();

  Future<Location?> getLocation(String placeId) async {
    final response = await _getPlaceLocationUseCase(placeId);
    if (response is DataSuccess) {
      return response.data;
    } else {
      return null;
    }
  }
}
