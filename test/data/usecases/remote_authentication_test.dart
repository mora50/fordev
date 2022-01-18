import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecase.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:mockito/mockito.dart';

//Create a implementation of abstract httpClient with Mockito
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    /* Abbreviation of system under test
    It's a name to represent what class is passing through the test*/
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Shoudl call HttpCliente with correct URL', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, "password": params.secret}));
  });
}
