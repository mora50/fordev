import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecase.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/authentication.dart';
import 'package:mocktail/mocktail.dart';

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

  test('Should call HttpCliente with correct URL', () async {
    when(() => httpClient.request(
            url: url, method: any(named: 'method'), body: any(named: 'body')))
        .thenAnswer((_) async =>
            {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut.auth(params);

    verify(() => httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, "password": params.secret}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(() => httpClient.request(
        url: url,
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    when(() => httpClient.request(
        url: url,
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    when(() => httpClient.request(
        url: url,
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });
  test('Should return an Account if HttpClient returns 200', () async {
    final accessToken = faker.guid.guid();
    when(() =>
        httpClient.request(
            url: url,
            method: any(named: 'method'),
            body: any(named: 'body'))).thenAnswer(
        (_) async => {'accessToken': accessToken, 'name': faker.person.name()});

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });
  test(
      'Should throw UnexpectedError if HttpClient return 200 with invalid data',
      () async {
    when(() => httpClient.request(
            url: any(named: "url"),
            method: any(named: 'method'),
            body: any(named: 'body')))
        .thenAnswer((_) async => {'invalid_key': "invalid_value"});

    final account = sut.auth(params);

    expect(account, throwsA(DomainError.unexpected));
  });
}
