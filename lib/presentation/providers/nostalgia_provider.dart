import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/usecases/bookmark_usecase.dart';
import 'package:wehere_client/domain/usecases/cancel_bookmark_usecase.dart';
import 'package:wehere_client/domain/usecases/delete_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_usecase.dart';
import 'package:wehere_client/presentation/providers/api_provider.dart';

class NostalgiaProvider extends ApiProvider {
  final GetNostalgiaUseCase _getNostalgiaUseCase;
  final DeleteNostalgiaUseCase _deleteNostalgiaUseCase;
  final BookmarkUseCase _bookmarkUseCase;
  final CancelBookmarkUseCase _cancelBookmarkUseCase;

  NostalgiaProvider(this._getNostalgiaUseCase, this._deleteNostalgiaUseCase,
      this._bookmarkUseCase, this._cancelBookmarkUseCase);

  Nostalgia? nostalgia;
  bool isDeleted = false;
  bool isBookmarked = false;

  @override
  void initialize() {
    nostalgia = null;
    isLoading = true;
    error = null;
    isBookmarked = false;
  }

  Future<void> loadItem(String id, Location location) async {
    final response = await _getNostalgiaUseCase(
        GetNostalgiaDetailParams(id, location.latitude, location.longitude));
    if (response is DataSuccess) {
      nostalgia = response.data;
      isBookmarked = response.data!.isBookmarked;
    } else {
      error = response.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> delete() async {
    isLoading = true;
    notifyListeners();

    final response = await _deleteNostalgiaUseCase(nostalgia!.id);
    if (response is DataFailed) {
      error = response.error;
    } else {
      nostalgia == null;
      isDeleted = true;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> bookmark() async {
    if (isBookmarked) return;
    final response = await _bookmarkUseCase(nostalgia!.id);
    if (response is DataSuccess) {
      isBookmarked = true;
    } else {
      error = response.error;
    }
    notifyListeners();
  }

  Future<void> cancelBookmark() async {
    if (!isBookmarked) return;
    final response = await _cancelBookmarkUseCase(nostalgia!.id);
    if (response is DataSuccess) {
      isBookmarked = false;
    } else {
      error = response.error;
    }
    notifyListeners();
  }
}
