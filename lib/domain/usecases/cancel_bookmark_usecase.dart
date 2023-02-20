import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class CancelBookmarkUseCase extends UseCase<DataState, String> {
  final NostalgiaRepository _nostalgiaRepository;

  CancelBookmarkUseCase(this._nostalgiaRepository);

  @override
  Future<DataState> call(String params) async {
    return await _nostalgiaRepository.cancelBookmark(params);
  }
}
