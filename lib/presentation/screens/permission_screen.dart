import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/widgets/background_image.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Widget _descriptionItem(BuildContext context, String text) => Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 6),
        child: Row(children: [
          Icon(Icons.arrow_right, color: Colors.white),
          IText(text, size: FontSize.small, weight: FontWeight.bold)
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: deviceHeight / 8, bottom: deviceHeight / 8),
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IText(
                                '서비스를 이용하기 위해,\n위치 정보 제공에 동의해주세요.',
                                weight: FontWeight.bold,
                                align: TextAlign.center,
                              ),
                              Column(
                                children: [
                                  IText('위치정보는 다음의 목적으로 활용돼요.'),
                                  Container(height: 8),
                                  _descriptionItem(
                                      context, '현재 위치에서 나의 추억을 작성해요'),
                                  _descriptionItem(
                                      context, '내 주변에 있는 추억 장소를 알려줘요'),
                                ],
                              ),
                              IText('* 소중한 고객님의 개인정보를 위해\n위치정보는 어디에도 저장하지 않아요',
                                  align: TextAlign.center,
                                  size: FontSize.small),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white,
                                              width: 0.8))),
                                  child: IText('네, 이해했어요!'),
                                ),
                                onTap: () {
                                  Provider.of<LocationProvider>(context,
                                          listen: false)
                                      .getLocation();
                                },
                              )
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
