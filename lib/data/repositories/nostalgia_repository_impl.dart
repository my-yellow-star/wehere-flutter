import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/params/update_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/nostalgia_service.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
import 'package:wehere_client/domain/entities/statistic_summary.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';

class NostalgiaRepositoryImpl extends NostalgiaRepository {
  final NostalgiaService _nostalgiaService = NostalgiaService();

  @override
  Future<Pagination<NostalgiaSummary>> getList(
      GetNostalgiaParams params) async {
    return await _nostalgiaService.getList(params);
  }

  @override
  Future<DataState<Nostalgia>> get(GetNostalgiaDetailParams params) async {
    try {
      final response = await _nostalgiaService.get(params);
      return DataSuccess(response);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<StatisticSummary>> getStatisticSummary(
      String memberId) async {
    try {
      final response = await _nostalgiaService.getStatisticSummary(memberId);
      return DataSuccess(response);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<String>> create(CreateNostalgiaParams params) async {
    try {
      final response = await _nostalgiaService.create(params);
      return DataSuccess(response);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

  @override
  Future<DataState<String>> update(UpdateNostalgiaParams params) async {
    try {
      await _nostalgiaService.update(params);
      return DataSuccess(params.id);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }
}
