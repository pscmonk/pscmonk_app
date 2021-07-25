import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jiffy/jiffy.dart';

class WordPress {
  final apiUrl = "https://blog.pscmonk.com/wp-json";

  Future<Map> getResponse(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map responseContent = {
        "body": response.body,
        "headers": response.headers
      };
      return responseContent;
    } else {
      return getResponse(url);
    }
  }

  Future<Map> getPosts(pageNo) async {
    Map response = await getResponse("$apiUrl/wp/v2/posts?_embed&page=$pageNo");

    List posts = json.decode(response["body"]);

    int pagesCount = int.parse(response["headers"]["x-wp-totalpages"]);

    List newList = [];
    for (int i = 0; i < posts.length; i++) {
      Map post = posts[i];
      String title = post["title"]["rendered"].toString();
      String link = post["link"].toString();

      String thumbnailURL = "https://i.imgur.com/zjIQCvB.png"; //Fallback
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

    return {"posts": newList, "pagesCount": pagesCount};
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
