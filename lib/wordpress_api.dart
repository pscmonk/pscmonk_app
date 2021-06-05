import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:jiffy/jiffy.dart';

class WordPress {
  final apiUrl = "https://pscmonk.com/wp-json/";

  Future<String> getResonse(url) async {
    final response = await http.get(Uri.parse(apiUrl + url));
    if (response.statusCode == 200) {
      String responseContent = response.body;
      return responseContent;
    } else {
      return getResonse(url);
    }
  }

  Future<List> getPosts() async {
    String response = await getResonse("wp/v2/posts?_embed");
    List posts = json.decode(response);
    List newList = [];
    for (int i = 0; i < posts.length; i++) {
      Map post = posts[i];
      var title = post["title"]["rendered"].toString();
      var thumbnailURL = post["_embedded"]["wp:featuredmedia"][0]
              ["media_details"]["sizes"]["thumbnail"]["source_url"]
          .toString();
      var link = post["link"].toString();
      String excerptSmall = post["excerpt"]["rendered"].toString();
      String datePublished = post["date"];
      newList.add({
        "name": capitalize(title),
        "thumbnail": thumbnailURL,
        "link": link,
        "desc": excerpt(excerptSmall, 600),
        "time_diff": getTimeDifferenceFromNow(datePublished)
      });
    }
    dev.log(json.encode(newList));
    return newList;
  }

  excerpt(String string, length) {
    String expt = string.length < length ? "" : "...";
    length = string.length < length ? string.length : length;
    return string.substring(0, length) + expt;
  }

  String capitalize(string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  String getTimeDifferenceFromNow(then) {
    return Jiffy(then).fromNow();
  }
}
