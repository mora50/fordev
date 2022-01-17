import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });
}

abstract class HttpClient {
  request({required String url, required String method}) => null;
}

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
    await sut.auth();
    verify(httpClient.request(url: url, method: 'post'));
  });
}
