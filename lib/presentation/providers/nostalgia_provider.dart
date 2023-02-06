import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/usecases/delete_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class NostalgiaProvider extends ApiProvider {
  final GetNostalgiaUseCase _getNostalgiaUseCase;
  final DeleteNostalgiaUseCase _deleteNostalgiaUseCase;

  NostalgiaProvider(this._getNostalgiaUseCase, this._deleteNostalgiaUseCase);

  Nostalgia? nostalgia;
  bool isDeleted = false;

  @override
  void initialize() {
    nostalgia = null;
    isLoading = true;
    error = null;
  }

  Future<void> loadItem(String id, Location location) async {
    final response = await _getNostalgiaUseCase(
        GetNostalgiaDetailParams(id, location.latitude, location.longitude));
    if (response is DataSuccess) {
      nostalgia = response.data;
    } else {
      error = response.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> delete() async {
    isLoading = true;
    notifyListeners();

    final response = await _deleteNostalgiaUseCase(nostalgia!.id);
    if (response is DataFailed) {
      error = response.error;
    } else {
      nostalgia == null;
      isDeleted = true;
    }

    isLoading = false;
    notifyListeners();
  }
}
