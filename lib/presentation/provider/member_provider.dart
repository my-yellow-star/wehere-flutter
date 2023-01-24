import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';
import 'package:wehere_client/presentation/provider/api_provider.dart';

class MemberProvider extends ApiProvider {
  final GetProfileUseCase _getProfileUseCase;

  MemberProvider(this._getProfileUseCase);

  Member? _member;

  Member? get member => _member;

  Future<void> getMember() async {
    isLoading = true;
    notifyListeners();

    final response = await _getProfileUseCase();
    if (response is DataSuccess) {
      _member = response.data;
    } else {
      error = response.error;
    }
    isLoading = false;
    notifyListeners();
  }
}
