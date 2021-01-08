import 'package:http/http.dart' as http;
import 'dart:convert';

class Networking {
  Networking(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);
    var data = response.body;
    var dataCode = jsonDecode(data);

    print(dataCode);
    if (response.statusCode == 200) {
      return dataCode;
    } else {
      return response.statusCode;
    }
  }
}
