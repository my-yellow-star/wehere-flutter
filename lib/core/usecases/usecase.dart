abstract class UseCase<T, P> {
  Future<T> call(P params);
}

abstract class SimpleUseCase<T> {
  Future<T> call();
}
