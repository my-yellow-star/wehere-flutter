import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/update_member.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/usecases/get_other_profile_usecase.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';
import 'package:wehere_client/domain/usecases/update_member_usecase.dart';
import 'package:wehere_client/domain/usecases/upload_file_usecase.dart';
import 'package:wehere_client/presentation/image.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class MemberProvider extends ApiProvider {
  final GetProfileUseCase _getProfileUseCase;
  final GetOtherProfileUseCase _getOtherProfileUseCase;
  final UpdateMemberUseCase _updateMemberUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  Member? member;
  String nickname = '';
  String? description = '';
  IImageSource? profileImage;
  IImageSource? backgroundImage;

  MemberProvider(this._getProfileUseCase, this._getOtherProfileUseCase,
      this._updateMemberUseCase, this._uploadFileUseCase);

  @override
  void initialize() {
    isLoading = false;
    error = null;
  }

  Future<void> loadUser({String? id}) async {
    final response = id == null
        ? await _getProfileUseCase()
        : await _getOtherProfileUseCase(id);
    if (response is DataSuccess) {
      member = response.data!;
      nickname = member!.nickname;
      description = member!.description;
      profileImage = member!.profileImageUrl != null
          ? IImageSource(member!.profileImageUrl!, ImageType.network)
          : null;
      backgroundImage = member!.backgroundImageUrl != null
          ? IImageSource(member!.backgroundImageUrl!, ImageType.network)
          : null;
    } else {
      error = response.error;
    }
    notifyListeners();
  }

  Future<void> update() async {
    isLoading = true;
    notifyListeners();

    final response = await _updateMemberUseCase(UpdateMemberParams(
        nickname: nickname,
        description: description,
        profileImageUrl: await _uploadImage(profileImage),
        backgroundImageUrl: await _uploadImage(backgroundImage)));

    if (response is DataSuccess) {
      await loadUser();
    } else {
      error = response.error;
    }

    isLoading = false;
    notifyListeners();
  }

  void updateNickname(String value) {
    nickname = value;
  }

  void updateDescription(String value) {
    description = value;
  }

  void updateProfileImage(IImageSource? image) {
    profileImage = image;
    notifyListeners();
  }

  void updateBackgroundImage(IImageSource? image) {
    backgroundImage = image;
    notifyListeners();
  }

  Future<String?> _uploadImage(IImageSource? image) async {
    if (image == null) return null;
    if (image.type == ImageType.network) return image.path;
    final file = MultipartFile.fromFileSync(image.path);

    final response = (await _uploadFileUseCase([file])).first;
    return response.data;
  }
}
