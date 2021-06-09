import "package:flutter/material.dart";
import "../wordpress_api.dart";
import 'package:url_launcher/url_launcher.dart';
import 'misc/loading.dart';

class Home extends StatefulWidget {
  final String title;
  const Home({Key? key, required this.title}) : super(key: key);
  _HomeActivity createState() => _HomeActivity(title);
}

class _HomeActivity extends State<Home> {
  final title;
  _HomeActivity(this.title);

  WordPress wp = WordPress();

  List posts = [];
  bool loading = true;
  int pageIndex = 0;
  int totalPages = 1;

  Future getPosts() async {
    pageIndex++;
    if (pageIndex <= totalPages) {
      setState(() {
        loading = true;
      });
      Map postsList = await wp.getPosts(pageIndex);
      setState(() {
        posts.addAll(postsList["posts"]);
        totalPages = postsList["pagesCount"];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            var metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              if (metrics.pixels >= 100) getPosts();
            }
            return true;
          },
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                        child: Text(
                          "Updates",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/header.jpg"),
                            fit: BoxFit.cover)),
                  )
                ]..addAll(posts
                    .map((e) => Post(
                        e["name"], e["thumbnail"], e["link"], e["time_diff"]))
                    .toList()),
              ),
              loading ? Loading() : Text("")
            ],
          )),
    );
  }
}

class Post extends StatelessWidget {
  final String titleT;
  final String imageL;
  final String _url;
  final String timeDifference;
  Post(this.titleT, this.imageL, this._url, this.timeDifference);

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.55;
    return InkWell(
      onTap: _launchURL,
      child: Container(
        height: 130,
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.all(0),
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  imageL.toString(),
                  height: 120,
                  width: 120,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Container(
                  width: cWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          titleT,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w400),
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          timeDifference,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black38),
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
