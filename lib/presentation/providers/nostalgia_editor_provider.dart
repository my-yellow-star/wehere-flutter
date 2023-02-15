import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/params/marker_color.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/params/update_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/usecases/create_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/update_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/upload_file_usecase.dart';
import 'package:wehere_client/presentation/image.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class NostalgiaEditorProvider extends ApiProvider {
  final CreateNostalgiaUseCase _createNostalgiaUseCase;
  final UpdateNostalgiaUseCase _updateNostalgiaUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final GetNostalgiaUseCase _getNostalgiaUseCase;

  String? id;
  String title = '';
  String description = '';
  NostalgiaVisibility visibility = NostalgiaVisibility.all;
  List<IImageSource> images = [];
  MarkerColor markerColor = Constant.markerColors.first;

  NostalgiaEditorProvider(this._createNostalgiaUseCase, this._uploadFileUseCase,
      this._updateNostalgiaUseCase, this._getNostalgiaUseCase);

  @override
  void initialize() {
    title = '';
    description = '';
    visibility = NostalgiaVisibility.all;
    markerColor = Constant.markerColors.first;
    images = [];
    isLoading = false;
    error = null;
  }

  Future<void> loadNostalgia(String id, Location location) async {
    final response = await _getNostalgiaUseCase(
        GetNostalgiaDetailParams(id, location.latitude, location.longitude));
    if (response is DataSuccess) {
      final nostalgia = response.data!;
      this.id = nostalgia.id;
      title = nostalgia.title;
      description = nostalgia.description;
      visibility = nostalgia.visibility;
      images = nostalgia.images
          .map((url) => IImageSource(url, ImageType.network))
          .toList();
    } else {
      error = response.error;
    }
    notifyListeners();
  }

  Future<void> create(Location location) async {
    isLoading = true;
    notifyListeners();

    final response = await _createNostalgiaUseCase(CreateNostalgiaParams(
        title: title,
        description: description,
        visibility: visibility,
        images: await _uploadImages(images),
        latitude: location.latitude,
        longitude: location.longitude,
        markerColor: markerColor));
    if (response is DataSuccess) {
      id = response.data!;
    } else {
      error = response.error;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> update() async {
    isLoading = true;
    notifyListeners();

    final response = await _updateNostalgiaUseCase(UpdateNostalgiaParams(
        id: id!,
        title: title.isNotEmpty ? title : null,
        description: description.isNotEmpty ? description : null,
        visibility: visibility,
        markerColor: markerColor,
        images: await _uploadImages(images)));
    if (response is DataFailed) {
      error = response.error;
    }
    isLoading = false;
    notifyListeners();
  }

  void updateTitle(String value) {
    title = value;
  }

  void updateDescription(String value) {
    description = value;
  }

  void updateVisibility(NostalgiaVisibility value) {
    visibility = value;
    notifyListeners();
  }

  void updateMarkerColor(MarkerColor value) {
    markerColor = value;
    notifyListeners();
  }

  Future<void> addImages(List<IImageSource> images) async {
    this.images = [...this.images, ...images];
    notifyListeners();
  }

  void deleteImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  bool isWriting() {
    return title.isNotEmpty || description.isNotEmpty || images.isNotEmpty;
  }

  Future<List<String>> _uploadImages(List<IImageSource> images) async {
    final alreadyUploaded = images
        .where((e) => e.type == ImageType.network)
        .map((e) => e.path)
        .toList();
    final files = images
        .where((e) => e.type == ImageType.file)
        .map((e) => MultipartFile.fromFileSync(e.path))
        .toList();

    final responses = await _uploadFileUseCase(files);
    final List<String> uploadedUrls = alreadyUploaded;
    for (var response in responses) {
      if (response is DataSuccess) {
        uploadedUrls.add(response.data!);
      }
    }
    return uploadedUrls;
  }
}
