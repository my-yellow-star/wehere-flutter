import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';

class ResignUseCase extends SimpleUseCase<DataState<dynamic>> {
  final MemberRepository _memberRepository;

  ResignUseCase(this._memberRepository);

  @override
  Future<DataState> call() async {
    return await _memberRepository.resign();
  }
}
