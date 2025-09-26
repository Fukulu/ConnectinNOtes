sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T data;
  const Ok(this.data);
}

class Err<T> extends Result<T> {
  final String message;
  const Err(this.message);
}

// ✅ Extension ile when ekledik
extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T data) ok,
    required R Function(String message) err,
  }) {
    if (this is Ok<T>) {
      return ok((this as Ok<T>).data);
    } else if (this is Err<T>) {
      return err((this as Err<T>).message);
    }
    throw Exception("Unhandled case in Result.when");
  }
}
