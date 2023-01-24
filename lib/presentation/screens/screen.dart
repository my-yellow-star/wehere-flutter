import 'package:flutter/cupertino.dart';

abstract class StatelessScreen extends StatelessWidget {
  final String path;

  const StatelessScreen({super.key, required this.path});
}
