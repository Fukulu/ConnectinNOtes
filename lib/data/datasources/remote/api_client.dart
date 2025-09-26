import 'package:dio/dio.dart';
import '../../../core/env.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));

  ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;
        final token = await user?.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ));
  }

  Dio get client => _dio;
}
