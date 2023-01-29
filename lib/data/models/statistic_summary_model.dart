import 'package:wehere_client/data/models/location_model.dart';
import 'package:wehere_client/domain/entities/statistic_summary.dart';

class StatisticSummaryModel extends StatisticSummary {
  const StatisticSummaryModel(
      super.totalCount, super.accumulatedDistance, super.lastLocation);

  factory StatisticSummaryModel.fromJson(dynamic json) {
    return StatisticSummaryModel(
        json['totalCount'],
        json['accumulatedDistance'],
        LocationModel.fromJson(json['lastLocation']));
  }
}
