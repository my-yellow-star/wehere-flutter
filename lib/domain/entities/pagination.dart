import 'package:equatable/equatable.dart';

class Pagination<T> extends Equatable {
  final int total;
  final List<T> items;
  final int? nextPage;
  final bool end;

  const Pagination(
      {required this.total,
      required this.items,
      this.nextPage,
      required this.end});

  @override
  List<Object?> get props => throw UnimplementedError();
}
