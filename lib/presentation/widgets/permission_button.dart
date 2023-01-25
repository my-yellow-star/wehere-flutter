import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';

class PermissionButton {
  static void _onPressed(LocationProvider provider) async {
    await provider.requestPermission();
  }

  static Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context, listen: true);
    return TextButton(
        onPressed: () => _onPressed(provider), child: Text('click'));
  }
}
