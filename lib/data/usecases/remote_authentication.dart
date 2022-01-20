import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/http/models/models.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final response = await httpClient.request(
          url: url,
          method: 'post',
          body: RemoteAuthenticationParams.fromDomain(params).toJson());

      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (err) {
      throw err == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
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
