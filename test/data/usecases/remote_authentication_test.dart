import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecase.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:mockito/mockito.dart';

//Create a implementation of abstract httpClient with Mockito
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    /* Abbreviation of system under test
    It's a name to represent what class is passing through the test*/
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Shoudl call HttpCliente with correct URL', () async {
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, "password": params.secret}));
  });

  test('Shoudl throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(url: url, method: "post", body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Shoudl throw UnexpectedError if HttpClient returns 404', () async {
    when(httpClient.request(url: url, method: "post", body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Shoudl throw UnexpectedError if HttpClient returns 500', () async {
    when(httpClient.request(url: url, method: "post", body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
