import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/data/datasources/nostalgia_service.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class NostalgiaRepositoryImpl extends NostalgiaRepository {
  final NostalgiaService _nostalgiaService = NostalgiaService();

  @override
  Future<Pagination<NostalgiaSummary>> getList(
      GetNostalgiaParams params) async {
    return await _nostalgiaService.getList(params);
  }
}
