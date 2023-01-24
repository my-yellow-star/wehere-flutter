import 'package:wehere_client/domain/entities/pagination.dart';

class PaginationModel<T> extends Pagination<T> {
  const PaginationModel({required total, required items, nextPage})
      : super(
            total: total,
            items: items,
            nextPage: nextPage,
            end: nextPage == null ? true : false);

  factory PaginationModel.fromJson(dynamic json, Function itemFromJson) {
    return PaginationModel(
      total: json['total'],
      nextPage: json['nextPage'],
      items:
          List<T>.from(json['items'].map((itemJson) => itemFromJson(itemJson))),
    );
  }
}
