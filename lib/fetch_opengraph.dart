import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:opengraph/entities/open_graph_entity.dart';

class OpenGraphRequest {
  final String url;
  final String userAgent;

  OpenGraphRequest(this.url, this.userAgent);

  static Future<OpenGraphEntity> fetch(String url) async {
    final String _url = "https://dev.graciaydevocion.com/api/v2/open-graph?url=$url";
    final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(_url));
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final json = jsonDecode(responseBody);
        httpClient.close();
        return OpenGraphEntity.fromJson(json["data"]);
      } else {
        return OpenGraphEntity.fromJson({
          "title": "",
          "description": "",
          "locale": "",
          "type": "",
          "url": "",
          "site_name": "",
          "updated_time": "",
          "image": "",
          "image_secure_url": "",
          "image_width": "",
          "image_height": "",
          "image_alt": "",
          "image_type": "",
          "twitter_card": "",
          "twitter_title": "",
          "twitter_description": "",
          "twitter_site": ""
        });
      }
  }

}