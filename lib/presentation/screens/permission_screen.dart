import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/routes.dart';
import 'package:wehere_client/presentation/screens/map_screen.dart';
import 'package:wehere_client/presentation/widgets/permission_button.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final permitted =
          Provider.of<LocationProvider>(context, listen: false).permitted;
      if (permitted) {
        Routes.replace(context, MapScreen());
      }
    });
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('위치 정보를 허용해주세요',
              style: TextStyle(color: Colors.white, fontSize: 24)),
          PermissionButton.build(context)
        ],
      ),
    );
  }
}
