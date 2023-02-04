import 'dart:convert';
import 'dart:io';
import 'dart:async';

main() async {
  String url =
      'https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  Map map = {
    'data': {'apikey': '12345678901234567890'},
  };

  print(await postRequest(url, map));
}

Future<String> postRequest(String url, Map jsonMap) async {
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}
