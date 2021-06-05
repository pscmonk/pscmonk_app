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

  List posts = [];
  bool loading = true;

  Future getPosts() async {
    WordPress wp = WordPress();
    List postsList = await wp.getPosts();
    setState(() {
      posts = postsList;
      loading = false;
    });
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
      body: loading
          ? Loading()
          : ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Recent Posts",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.all(15),
                      )
                    ]..addAll(posts
                        .map((e) => Post(e["name"], e["thumbnail"], e["desc"],
                            e["link"], e["time_diff"]))
                        .toList()),
                  )
                ]),
    );
  }
}

class Post extends StatelessWidget {
  final String titleT;
  final String imageL;
  final String desc;
  final String _url;
  final String timeDifference;
  Post(this.titleT, this.imageL, this.desc, this._url, this.timeDifference);

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.5;
    return InkWell(
      onTap: _launchURL,
      child: Container(
        height: 130,
        padding: EdgeInsets.all(15),
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.all(0),
          elevation: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageL.toString(),
                width: 100,
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: cWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          titleT,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
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
