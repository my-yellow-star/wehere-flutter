import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/params/update_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/entities/statistic_summary.dart';

abstract class NostalgiaRepository {
  Future<Pagination<NostalgiaSummary>> getList(GetNostalgiaParams params);

  Future<DataState<Nostalgia>> get(GetNostalgiaDetailParams params);

  Future<DataState<StatisticSummary>> getStatisticSummary(String memberId);

  Future<DataState<String>> create(CreateNostalgiaParams params);

  Future<DataState<String>> update(UpdateNostalgiaParams params);

  Future<DataState<dynamic>> delete(String nostalgiaId);
}
