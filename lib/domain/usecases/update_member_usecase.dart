import 'package:wehere_client/core/params/update_member.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';

class UpdateMemberUseCase
    extends UseCase<DataState<dynamic>, UpdateMemberParams> {
  final MemberRepository _memberRepository;

  UpdateMemberUseCase(this._memberRepository);

  @override
  Future<DataState> call(UpdateMemberParams params) async {
    return await _memberRepository.update(params);
  }
}
