import 'dart:ffi';

import 'package:wehere_client/core/params/pagination.dart';

class GetBookmarkParams extends PaginationParams {
  final Double latitude;
  final Double longitude;
  final String? memberId;

  GetBookmarkParams(
      {required page,
      required size,
      required this.latitude,
      required this.longitude,
      this.memberId})
      : super(page, size);
}
