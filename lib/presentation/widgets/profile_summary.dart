import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/entities/statistic_summary.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class ProfileSummaryContainer extends StatelessWidget {
  final Member member;
  final StatisticSummary? summary;

  const ProfileSummaryContainer(
      {super.key, required this.member, required this.summary});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Column(
            children: [
              UnconstrainedBox(
                child: GlassmorphicContainer(
                  height: size.height * .5,
                  width: size.width,
                  borderRadius: 0,
                  border: 0,
                  linearGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(1)
                      ]),
                  blur: 3,
                  borderGradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.0)
                  ]),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                IText(
                                  '추억 ${summary?.totalCount ?? 0}개',
                                  weight: FontWeight.w100,
                                ),
                                IText(
                                  '여행거리 ${((summary?.accumulatedDistance ?? 0) / 1000).round().toString()}km',
                                  weight: FontWeight.w100,
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: size.height * .15),
                      child:
                          ProfileImage(size: 80, url: member.profileImageUrl)),
                  Container(height: 16),
                  IText(
                    member.nickname,
                    weight: FontWeight.w200,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}