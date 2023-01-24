import 'package:equatable/equatable.dart';

class Authentication extends Equatable {
  final String provider;

  const Authentication(this.provider);

  @override
  List<Object?> get props => [provider];
}
