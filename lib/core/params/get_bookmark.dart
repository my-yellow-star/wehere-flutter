import 'package:wehere_client/core/params/pagination.dart';

class GetBookmarkParams extends PaginationParams {
  final double latitude;
  final double longitude;
  final String? memberId;

  GetBookmarkParams(
      {required page,
      required size,
      required this.latitude,
      required this.longitude,
      this.memberId})
      : super(page, size);
}
