import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/widgets/clipper.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class CreateNostalgiaBubble extends StatelessWidget {
  const CreateNostalgiaBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.blue,
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ]),
                child: IText(
                  '지금 그곳의 추억을 남겨보세요!',
                  color: Colors.blue,
                  align: TextAlign.center,
                  size: FontSize.small,
                ),
              ),
            )),
        Positioned(
          bottom: 42,
          left: 0,
          right: 0,
          child: Center(
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: Colors.white,
                width: 18,
                height: 18 / 2,
              ),
            ),
          ),
        )
      ],
    );
  }
}
