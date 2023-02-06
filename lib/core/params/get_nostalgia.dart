import 'package:wehere_client/core/params/pagination.dart';

class GetNostalgiaParams extends PaginationParams {
  late final String condition;
  final double? maxDistance;
  final double? latitude;
  final double? longitude;

  GetNostalgiaParams({
    required page,
    required size,
    this.maxDistance,
    this.latitude,
    this.longitude,
    required NostalgiaCondition condition,
  }) : super(page, size) {
    this.condition = condition.name.toUpperCase();
  }
}

class GetNostalgiaDetailParams {
  final String nostalgiaId;
  final double? latitude;
  final double? longitude;

  GetNostalgiaDetailParams(this.nostalgiaId, this.latitude, this.longitude);
}

enum NostalgiaCondition { around, member, recent }
