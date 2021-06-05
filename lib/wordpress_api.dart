import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';

class WordPress {
  final apiUrl = "https://pscmonk.com/wp-json";

  Future<String> getResponse(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String responseContent = response.body;
      return responseContent;
    } else {
      return getResponse(url);
    }
  }

  Future<List> getPosts() async {
    String response = await getResponse("$apiUrl/wp/v2/posts?_embed");
    List posts = json.decode(response);
    List newList = [];
    for (int i = 0; i < posts.length; i++) {
      Map post = posts[i];
      String title = post["title"]["rendered"].toString();
      String link = post["link"].toString();

      String thumbnailURL =
          "https://pscmonk.com/wp-content/uploads/2021/06/cropped-resize.png";
      List? featuredMedia = post["_embedded"]["wp:featuredmedia"];
      String datePublished = post["date_gmt"].toString();
      if (featuredMedia != null) {
        thumbnailURL = featuredMedia[0]["media_details"]["sizes"]["thumbnail"]
                ["source_url"]
            .toString();
      }

      newList.add({
        "name": capitalize(title),
        "thumbnail": thumbnailURL,
        "link": link,
        "time_diff": getTimeDifferenceFromNow(datePublished),
      });
    }
    //dev.log(json.encode(newList));
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
    return Jiffy(then + "+00:00").fromNow();
  }
}
