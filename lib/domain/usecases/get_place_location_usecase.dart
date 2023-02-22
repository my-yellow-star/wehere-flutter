import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/repositories/search_repository.dart';

class GetPlaceLocationUseCase extends UseCase<DataState<Location>, String> {
  final SearchRepository _searchRepository;

  GetPlaceLocationUseCase(this._searchRepository);

  @override
  Future<DataState<Location>> call(String params) async {
    return await _searchRepository.getPlaceLocation(params);
  }
}
