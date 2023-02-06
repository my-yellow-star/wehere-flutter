import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/usecases/create_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/upload_file_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class CreateNostalgiaProvider extends ApiProvider {
  final CreateNostalgiaUseCase _createNostalgiaUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  String? id;
  String title = '';
  String description = '';
  NostalgiaVisibility visibility = NostalgiaVisibility.all;
  List<XFile> images = [];

  CreateNostalgiaProvider(
      this._createNostalgiaUseCase, this._uploadFileUseCase);

  void initialize() {
    title = '';
    description = '';
    visibility = NostalgiaVisibility.all;
    images = [];
    isLoading = false;
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
    ));
    if (response is DataSuccess) {
      id = response.data!;
    } else {
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

  Future<void> addImages(List<XFile> images) async {
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

  Future<List<String>> _uploadImages(List<XFile> images) async {
    final files =
        images.map((e) => MultipartFile.fromFileSync(e.path)).toList();
    final responses = await _uploadFileUseCase(files);
    final List<String> uploadedUrls = [];
    for (var response in responses) {
      if (response is DataSuccess) {
        uploadedUrls.add(response.data!);
      }
    }
    return uploadedUrls;
  }
}
