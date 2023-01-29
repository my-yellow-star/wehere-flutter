import 'package:equatable/equatable.dart';
import 'package:wehere_client/domain/entities/location.dart';

class StatisticSummary extends Equatable {
  final int totalCount;
  final double accumulatedDistance;
  final Location? lastLocation;

  const StatisticSummary(
      this.totalCount, this.accumulatedDistance, this.lastLocation);

  @override
  List<Object?> get props => [totalCount, accumulatedDistance, lastLocation];
}
