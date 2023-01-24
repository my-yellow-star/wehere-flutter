import 'package:wehere_client/core/params/pagination.dart';

class GetNostalgiaParams extends PaginationParams {
  late final String condition;
  final int? maxDistance;
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

enum NostalgiaCondition { around, member, recent }
