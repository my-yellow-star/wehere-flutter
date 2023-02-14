import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';

class ClusteredPlace with ClusterItem {
  final NostalgiaSummary item;

  ClusteredPlace(this.item);

  LatLng _getPosition(NostalgiaSummary item) =>
      LatLng(item.location.latitude, item.location.longitude);

  @override
  LatLng get location => _getPosition(item);
}
