import 'dart:async';
import 'dart:convert';

import 'package:aloe/models/News.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<List<News>> _getNews() async {
  final response = await http.get(Uri.parse(
      "https://newsapi.org/v2/everything?q=Botanique&sortBy=popularity&apiKey=5c5ec550fd934ca0a833d6f458b25de1"));

  var jsonData = json.decode(response.body);

  List<News> articles = [];

  for (var articles in jsonData["articles"]) {
    News newArticle = News(articles["publishedAt"], articles["title"],
        articles["url"], articles["author"], articles["urlToImage"]);
    articles.add(newArticle);
  }

  return articles;
}

class NewsFetch extends StatefulWidget {
  @override
  _NewsFetchState createState() => _NewsFetchState();
}

class _NewsFetchState extends State<NewsFetch> {
  Future<News> futureNews;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getNews(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _launchURL(snapshot.data[index].url);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].urlToImage),
                      ),
                      title: Text(snapshot.data[index].title),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
