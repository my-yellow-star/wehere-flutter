import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';

abstract class NostalgiaRepository {
  Future<Pagination<NostalgiaSummary>> getList(GetNostalgiaParams params);
}
