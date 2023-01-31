import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/create_nostalgia.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/resources/logger.dart';
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
  List<String> images = [];

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
      images: images,
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

  Future<void> addImages(List<MultipartFile> files) async {
    isLoading = true;
    notifyListeners();
    final response = await _uploadFileUseCase(files);
    apiLogger.d(images);
    apiLogger.d(response);
    for (var element in response) {
      if (element is DataSuccess) {
        images = [...images, element.data!];
      }
    }
    apiLogger.d(images);
    isLoading = false;
    notifyListeners();
  }

  void deleteImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  bool isWriting() {
    return title.isNotEmpty || description.isNotEmpty || images.isNotEmpty;
  }
}
