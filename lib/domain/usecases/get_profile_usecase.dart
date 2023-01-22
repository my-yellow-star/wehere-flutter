import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';

class GetProfileUseCase implements SimpleUseCase<DataState<Member>> {
  final MemberRepository _memberRepository;

  GetProfileUseCase(this._memberRepository);

  @override
  Future<DataState<Member>> call() {
    return _memberRepository.getMyProfile();
  }
}
