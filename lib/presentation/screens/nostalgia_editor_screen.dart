import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_editor_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/screens/components/location_search_modal.dart';
import 'package:wehere_client/presentation/screens/components/marker_color_selector.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/back_button.dart';
import 'package:wehere_client/presentation/widgets/gallery.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/text.dart';
import 'package:wehere_client/presentation/widgets/upload_button.dart';
import 'package:wehere_client/presentation/widgets/visibility_dropdown.dart';

class NostalgiaEditorScreen extends StatefulWidget {
  const NostalgiaEditorScreen({super.key});

  @override
  _NostalgiaEditorScreenState createState() => _NostalgiaEditorScreenState();
}

class _NostalgiaEditorScreenState extends State<NostalgiaEditorScreen>
    with AfterLayoutMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  bool _editMode = false;

  static final _titleKey =
      GlobalKey<EditableTextState>(debugLabel: 'title key');

  static final _descriptionKey =
      GlobalKey<EditableTextState>(debugLabel: 'description key');

  @override
  void initState() {
    final provider = context.read<NostalgiaEditorProvider>();
    provider.initialize();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final provider = context.read<NostalgiaEditorProvider>();
    final location = context.read<LocationProvider>().location!;
    if (args != null) {
      provider.loadNostalgia(args as String, location).then((_) {
        _titleController.text = provider.title;
        _descriptionController.text = provider.description;
      });
      setState(() {
        _editMode = true;
      });
    } else {
      provider.initializeLocation(location);
    }
  }

  Future<void> _createOrUpdate() async {
    final nostalgia = context.read<NostalgiaEditorProvider>();
    if (nostalgia.title.isEmpty) {
      Alert.build(context, title: '필수 항목을 입력해주세요', description: '제목을 입력해주세요');
      return;
    }
    if (_editMode) {
      await nostalgia.update();
    } else {
      await nostalgia.create();
    }
    if (nostalgia.error == null && mounted) {
      context.read<RefreshPropagator>().propagate('nostalgia-list');
      Navigator.pushNamedAndRemoveUntil(
          context, 'nostalgia-detail', ModalRoute.withName('main'),
          arguments: nostalgia.id);
    }
  }

  void _onTapDateTimeSelector() {
    final provider = context.read<NostalgiaEditorProvider>();
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      onConfirm: (date) {
        provider.updateMemorizedAt(date);
      },
      currentTime: provider.memorizedAt ?? DateTime.now(),
      locale: LocaleType.ko,
    );
  }

  void _onTapLocationSelector() {
    showModalBottomSheet(
        context: context,
        builder: (context) => LocationSearchModal(onItemPressed: (searched) {
              context.read<NostalgiaEditorProvider>().updateLocation(searched);
            }));
  }

  Widget _underline() => Container(
        width: double.infinity,
        height: 0.5,
        color: Colors.grey.shade300,
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final nostalgia = context.watch<NostalgiaEditorProvider>();
    if (nostalgia.error != null) {
      Future.microtask(() {
        Alert.build(context,
            title: '오류', description: '오류가 발생했어요. 잠시 후 다시 시도해주세요.');
      });
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    nostalgia.images.isNotEmpty
                        ? Gallery(
                            height: size.height * .4,
                            width: size.width,
                            images: nostalgia.images,
                            onDeleteItem: nostalgia.deleteImage,
                          )
                        : Container(
                            height: size.height * .3,
                            width: size.width,
                            color: Colors.black,
                            child: Center(
                                child: IText('그곳의 사진을 올려보세요',
                                    weight: FontWeight.w100)),
                          ),
                    Positioned(
                      bottom: PaddingVertical.normal,
                      right: PaddingHorizontal.normal,
                      child: UploadButton(),
                    ),
                    SafeArea(
                        child: Container(
                            margin: EdgeInsets.only(
                              top: PaddingVertical.normal,
                              left: PaddingHorizontal.normal,
                            ),
                            child: RoundBackButton()))
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: PaddingHorizontal.normal,
                        right: PaddingHorizontal.normal,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: PaddingVertical.small,
                              bottom: PaddingVertical.small,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MarkerColorSelector(
                                  selected: nostalgia.markerColor,
                                  onSelected: (value) {
                                    nostalgia.updateMarkerColor(value);
                                  },
                                ),
                                VisibilityDropdown(
                                    selectedVisibility: nostalgia.visibility)
                              ],
                            ),
                          ),
                          _underline(),
                          InkWell(
                            onTap: _onTapDateTimeSelector,
                            child: Container(
                              padding: EdgeInsets.only(
                                top: PaddingVertical.small,
                                bottom: PaddingVertical.small,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: IconSize.normal,
                                    color: Colors.green,
                                  ),
                                  IText(
                                    nostalgia.memorizedAt?.parseString() ??
                                        '지금',
                                    size: FontSize.small,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            ),
                          ),
                          _underline(),
                          InkWell(
                            onTap: _onTapLocationSelector,
                            child: Container(
                              padding: EdgeInsets.only(
                                top: PaddingVertical.small,
                                bottom: PaddingVertical.small,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.place_rounded,
                                    size: IconSize.normal,
                                    color: Colors.blue,
                                  ),
                                  IText(
                                    nostalgia.address ?? '현위치',
                                    size: FontSize.small,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ),
                          ),
                          _underline(),
                          TextField(
                            autofocus: true,
                            key: _titleKey,
                            controller: _titleController,
                            onChanged: nostalgia.updateTitle,
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: '네가 있던 그곳',
                                hintStyle: TextStyle(
                                    color: ColorTheme.primary.withOpacity(0.2),
                                    fontWeight: FontWeight.bold),
                                border: InputBorder.none),
                            onSubmitted: (_) {
                              _descriptionFocusNode.requestFocus();
                            },
                          ),
                          TextField(
                            focusNode: _descriptionFocusNode,
                            key: _descriptionKey,
                            controller: _descriptionController,
                            onChanged: nostalgia.updateDescription,
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w200),
                            decoration: InputDecoration(
                                hintText: '지나고 보니 추억이었다',
                                hintStyle: TextStyle(
                                    color: ColorTheme.primary.withOpacity(0.2),
                                    fontWeight: FontWeight.w200),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 100.h,
                  child: SafeArea(
                    top: false,
                    child: InkWell(
                      onTap: _createOrUpdate,
                      child: Center(
                          child: IText(
                        '업로드',
                        weight: FontWeight.bold,
                      )),
                    ),
                  ),
                )
              ],
            ),
            nostalgia.isLoading
                ? Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
