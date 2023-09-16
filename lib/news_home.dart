import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

import 'news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int settingColor = 0xff1976d2;
  String url =
      "http://newsapi.org/v2/top-headlines?apiKey=33b24be8d9404eef8fed1bee30c73f2f&country=in";
  bool isLoaded = false;
  bool isLiked = false;

  List<Post> posts = [];

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        posts = (data["articles"] as List).map((post) {
          return Post.fromJSON(post);
        }).toList();

        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _buildCardTitle(String text) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
    );
  }

  _buildCardSubtitle(String text) {
    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black45,
          fontSize: 15,
          fontFamily: 'Raleway'),
    );
  }

  _buildNewsCard(Post post) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(post.url ?? ""));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Webview(post.url, post.title)));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            post.image != ''
                ? Stack(
                    children: <Widget>[
                      Container(
                        height: deviceHeight * 0.35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(post.image ?? ""))),
                      ),
                      Container(
                        height: deviceHeight * 0.35,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.center,
                                colors: [
                                  Colors.black.withOpacity(0.55),
                                  Colors.black.withOpacity(0.15)
                                ],
                                stops: const [
                                  0.5,
                                  3
                                ])),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: deviceHeight * 0.125,
                                  left: 8.0,
                                  right: 8.0),
                              child: Text(
                                post.title ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 1.25,
                                    fontSize: deviceHeight * 0.031,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Raleway'),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: _buildCardSubtitle(post.description ?? ""),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    post.publishedAt.toString(),
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontFamily: 'Raleway'),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    post.author ?? "",
                    style: TextStyle(fontSize: 15, color: Colors.blue[800]),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
                IconButton(icon: const Icon(Icons.share), onPressed: () {})
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(settingColor),
          title: const Text(
            "InstaNews",
            style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: isLoaded == true
            ? RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return _buildNewsCard(posts[index]);
                    }),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
