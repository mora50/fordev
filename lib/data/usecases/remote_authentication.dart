import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson());
  }

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({required this.email, required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(email: entity.email, password: entity.secret);

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
