import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class News{
  final String title;
  final String description;
  final String author;
  final String urlToImage;
  final String publishedAt;

  News(this.title, this.description, this.author, this.urlToImage, this.publishedAt);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            home: NewsHome(),
    );
  }
}

class NewsHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NewsState();
  }
}

class _NewsState extends State<NewsHome>{

  //void initState(){}

  Future<List<News>> getNews() async {
    var data = await http.get(
      'http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=2259d585e97b40a9b0fbfccc1de7640d'
    );

    var jsonData = json.decode(data.body);

    var newsData = jsonData['articles'];

    List<News> news = [];

    for(var data in newsData){
      News newsItem = News(
        data['title'],
        data['description'],
        data['author'],
        data['urlToImage'],
        data['publishedAt']
        );
        news.add(newsItem);
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(title: Text('HeadLine news')),
      body: Container(  
        child: FutureBuilder(
          future: getNews(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(  
                child: Center(
                  child: CircularProgressIndicator(),
                  ),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(  
                    onTap: (){
                      News news = new News(
                        snapshot.data[index].title,
                        snapshot.data[index].description,
                        snapshot.data[index].author,
                        snapshot.data[index].urlToImage,
                        snapshot.data[index].publishedAt);

                     Navigator.push(context,MaterialPageRoute(builder: (context) => 
                       new Details(news: news)
                      )
                      );
                    },

                    child: Card(  
                      child: Row(  
                        children: [
                          Container(  
                            width: 120.0, 
                            height: 120.0,
                            child: ClipRRect(  
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0)
                              ),
                              child: (snapshot.data[index].urlToImage == null)
                              ? Image.network('https://yt3.ggpht.com/a/AATXAJzP8iiqrbsEgxZHXXZynrPyJGPVbD3o4xIbov9tchg=s900-c-k-c0xffffffff-no-rj-mo')
                              : Image.network(
                                snapshot.data[index].urlToImage,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded(  
                            child: ListTile(  
                              title: Text(snapshot.data[index].title),
                              subtitle: Text(snapshot.data[index].author == null
                              ? 'Unknown' : snapshot.data[index].author),
                            ),
                          )
                        ]
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
      ),
    );
  }

}

class Details extends StatelessWidget{

  final News news;

  Details({this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: Center(  
        child: Container(  
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(  
                    height: 400.0,
                    child: Image.network(
                      this.news.urlToImage,
                      fit: BoxFit.fill,
                      )
                  ),
                  AppBar(  
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    elevation: 0, //shadow
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(  
                  children: [
                    SizedBox(height: 10.0),
                    Text(this.news.title,
                    style: TextStyle(  
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      wordSpacing: 0.6
                    ),
                    ),
                    SizedBox(height: 20.0),
                    Text(this.news.description,
                    style: TextStyle(  
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      wordSpacing: 0.3
                    ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(this.news.author == null
                        ? 'Unknown' : this.news.author,
                    style: TextStyle(  
                      color: Colors.grey,                      
                    ),
                    ),
                    Text(this.news.publishedAt,
                    style: TextStyle(  
                      color: Colors.grey,
                    ))
                      ],
                    )
                  ],
                ),
              ),
          ],)
        ),
      ),
      
    );
    
  }

}
