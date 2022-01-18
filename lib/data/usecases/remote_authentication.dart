import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: 'post', body: params.toJson());
  }

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });
}
