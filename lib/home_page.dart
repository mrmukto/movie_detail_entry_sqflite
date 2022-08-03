import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_detail_entry/db/temp_db.dart';
import 'package:movie_detail_entry/details_page.dart';
import 'package:movie_detail_entry/new_movie_page.dart';

import 'db/db_helper.dart';
import 'models/models.dart';


class HomePage extends StatefulWidget {
  static const String routeName = '/';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _movieList = <Movie>[];


  @override
  void didChangeDependencies() {
    _getData();
  }

  void _getData() {
    DbHelper.getAllMovies().then((list) {
      setState((){
        _movieList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movie List'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.pushNamed(
                      context,
                      NewMoviePage.routeName).then((value) {
                    _getData();
                  }),
            )
          ],
        ),
        body: _movieList.isEmpty ? Center(child: const Text('No movie found'),) :
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          children: _movieList.map((movie) => MovieItem(movie: movie)).toList(),
        ));
  }
}

class MovieItem extends StatelessWidget {
  final Movie movie;
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Hero(
              tag: movie.id!,
              child: Image.file(
                File(movie.image!),
                width: double.maxFinite,
                height: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 5,
            child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(
                        context,
                        MovieDetails.routeName,
                        arguments: movie
                    ),
                child: Text('Details')
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24,), topRight: Radius.circular(24))
                ),
                alignment: Alignment.center,

                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(movie.name!, style: TextStyle(color: Colors.white, fontSize: 18),),
                    Text(movie.subTitle!, style: TextStyle(color: Colors.white),),
                  ],
                )
            ),
          ),
          Positioned(
            bottom: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 30,),
                  Text('${movie.rating}', style: TextStyle(color: Colors.white, fontSize: 20),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

