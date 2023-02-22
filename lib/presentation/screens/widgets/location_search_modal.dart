import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/params/search_location.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';
import 'package:wehere_client/presentation/components/location_manager.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/search_location_provider.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class LocationSearchModal extends StatefulWidget {
  final Function(SearchedLocation) onItemPressed;

  const LocationSearchModal({Key? key, required this.onItemPressed})
      : super(key: key);

  @override
  State<LocationSearchModal> createState() => _LocationSearchModalState();
}

class _LocationSearchModalState extends State<LocationSearchModal> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<SearchLocationProvider>();
    provider.initialize();
    provider.registerLocation(context.read<LocationProvider>().location!);
  }

  void _onTextChanged(String value) {
    context.read<SearchLocationProvider>().updateKeyword(value);
  }

  void _onSelectItem(SearchedLocation item) async {
    Navigator.of(context).pop();
    if (item.location == null) {
      final location = await LocationManager().getLocation(item.id);
      final locatedItem = SearchedLocation(
          id: item.id,
          address: item.address,
          name: item.name,
          category: item.category,
          distance: item.distance,
          location: location);
      widget.onItemPressed(locatedItem);
    } else {
      widget.onItemPressed(item);
    }
  }

  List<Widget> _buildItems(List<SearchedLocation> items) {
    final size = MediaQuery.of(context).size;

    return items
        .map((item) => InkWell(
              onTap: () {
                _onSelectItem(item);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200))),
                padding: EdgeInsets.only(
                  top: PaddingVertical.small,
                  bottom: PaddingVertical.small,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * .8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          item.category != null
                              ? IText(
                                  item.category!,
                                  color: Colors.grey,
                                  size: FontSize.small,
                                  weight: FontWeight.w200,
                                )
                              : Container(),
                          IText(
                            item.name,
                            color: ColorTheme.primary,
                            size: FontSize.regular,
                          ),
                          IText(
                            item.address,
                            color: Colors.grey,
                            size: FontSize.small,
                          )
                        ],
                      ),
                    ),
                    item.distance != null
                        ? Column(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Colors.grey,
                              ),
                              IText(
                                item.distance!.parseDistance(),
                                color: Colors.grey,
                                size: FontSize.small,
                              )
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<SearchLocationProvider>();
    return Container(
      height: size.height * .8,
      padding: EdgeInsets.only(
        top: PaddingVertical.small,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: PaddingHorizontal.normal,
                right: PaddingHorizontal.normal,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IText(
                    '글로벌',
                    color: Colors.blue,
                    size: FontSize.small,
                  ),
                  SizedBox(width: PaddingHorizontal.tiny),
                  SizedBox(
                    height: IconSize.normal,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: CupertinoSwitch(
                        activeColor: Colors.blue,
                        value: provider.country == SearchLocationCountry.other,
                        onChanged: (value) {
                          provider.updateCountry(value
                              ? SearchLocationCountry.other
                              : SearchLocationCountry.korea);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: PaddingVertical.small),
            TextField(
              onChanged: _onTextChanged,
              style: TextStyle(
                  color: ColorTheme.primary, fontSize: FontSize.regular),
              decoration: InputDecoration(
                isDense: true,
                hintText: '위치 혹은 장소를 입력해주세요',
                hintStyle:
                    TextStyle(color: Colors.grey, fontSize: FontSize.regular),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: EdgeInsets.only(
                    bottom: PaddingVertical.normal,
                    left: PaddingHorizontal.normal),
              ),
            ),
            Container(height: PaddingVertical.normal),
            Expanded(
                child: ListView(
              padding: EdgeInsets.only(
                left: PaddingHorizontal.normal,
                right: PaddingHorizontal.normal,
              ),
              children: _buildItems(provider.items),
            ))
          ],
        ),
      ),
    );
  }
}
