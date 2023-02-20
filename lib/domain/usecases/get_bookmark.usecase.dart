import 'package:wehere_client/core/params/get_bookmark.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';

class GetBookmarkUseCase
    extends UseCase<Pagination<NostalgiaSummary>, GetBookmarkParams> {
  final MemberRepository _memberRepository;

  GetBookmarkUseCase(this._memberRepository);

  @override
  Future<Pagination<NostalgiaSummary>> call(GetBookmarkParams params) async {
    return await _memberRepository.getBookmarks(params);
  }
}
