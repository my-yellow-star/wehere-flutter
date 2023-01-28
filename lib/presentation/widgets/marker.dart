import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';

class IMarker extends StatelessWidget {
  final NostalgiaSummary item;
  static const double circleSize = 50;
  static const double circleBorder = 4;
  static const double triangleWidth = 12;
  static const color = ColorTheme.primary;

  const IMarker({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circleSize),
              border: Border.all(color: color, width: circleBorder)),
          child: ProfileImage(
            size: circleSize - (circleBorder * 2),
            url: item.member.profileImageUrl,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: circleSize - 1, left: (circleSize - triangleWidth) / 2),
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: color,
              width: triangleWidth,
              height: triangleWidth / 2,
            ),
          ),
        )
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
