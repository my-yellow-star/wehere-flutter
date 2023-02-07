import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';

class GetOtherProfileUseCase extends UseCase<DataState<Member>, String> {
  final MemberRepository _memberRepository;

  GetOtherProfileUseCase(this._memberRepository);

  @override
  Future<DataState<Member>> call(String params) async {
    return await _memberRepository.getOtherProfile(params);
  }
}
