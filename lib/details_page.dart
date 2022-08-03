import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_detail_entry/db/temp_db.dart';
import 'package:movie_detail_entry/models/models.dart';


class MovieDetails extends StatefulWidget {
  static const String routeName = '/details';
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Movie movie;
  @override
  void didChangeDependencies() {
    movie = ModalRoute.of(context)!.settings.arguments as Movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            //pinned: true,
            floating: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie.name!),
              background: Hero(
                tag: movie.id!,
                child: Image.file(
                  File(movie.image!),
                  width: double.maxFinite,
                  height: 300, fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text(movie.name!),
                subtitle: Text(movie.subTitle!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star),
                    Text('${movie.rating}')
                  ],
                ),
                tileColor: Colors.grey.shade300,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(details),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
