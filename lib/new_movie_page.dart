import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'db/db_helper.dart';
import 'package:movie_detail_entry/models/models.dart';

import 'db/temp_db.dart';



class NewMoviePage extends StatefulWidget {
  static const String routeName = '/newmovie';
  const NewMoviePage({Key? key}) : super(key: key);

  @override
  State<NewMoviePage> createState() => _NewMoviePageState();
}

class _NewMoviePageState extends State<NewMoviePage> {
  final _nameController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();
  String? _type;
  DateTime? _selectedDate;
  String? _imagePath;
  var _imageSource = ImageSource.camera;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Movie'),
        actions: [
          IconButton(
            onPressed: _saveMovie,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'Movie Name',
                  fillColor: Colors.grey.shade300,
                  filled: true
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 5,),
            TextFormField(
              controller: _subtitleController,
              decoration: InputDecoration(
                  labelText: 'Movie Subtitle',
                  fillColor: Colors.grey.shade300,
                  filled: true
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 5,),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _ratingController,
              decoration: InputDecoration(
                  labelText: 'Rating',
                  fillColor: Colors.grey.shade300,
                  filled: true
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if(double.parse(value) < 0.0 || double.parse(value) > 10.0) {
                  return 'Rating should be between 1.0 and 10.0';
                }
                return null;
              },
            ),
            const SizedBox(height: 5,),
            TextFormField(
              maxLines: 3,
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  fillColor: Colors.grey.shade300,
                  filled: true
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 5,),
            DropdownButtonFormField<String>(
              hint: Text('Select movie category'),
              value: _type,
              items: typeList.map((type) => DropdownMenuItem(
                child: Text(type),
                value: type,
              )
              ).toList(),
              onChanged: (value) {
                _type = value;
              },
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please select a movie type';
                }
                return null;
              },
            ),
            SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey.shade300,
              title: TextButton(
                child: const Text('Select Date'),
                onPressed: _selectDate,
              ),
              trailing: Text(_selectedDate == null ? DateTime.now().toIso8601String() : _selectedDate!.toIso8601String()),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Card(
                        child: _imagePath == null ?
                        Image.asset('images/placeholder.png', fit: BoxFit.cover,) :
                        Image.file(File(_imagePath!), fit: BoxFit.cover,),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        label: const Text('Capture'),
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          _imageSource = ImageSource.camera;
                          _getImage();
                        },
                      ),
                      TextButton.icon(
                        label: const Text('Gallery'),
                        icon: Icon(Icons.photo_album),
                        onPressed: () {
                          _imageSource = ImageSource.gallery;
                          _getImage();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year + 5));
    if(dt != null) {
      setState(() {
        _selectedDate = dt;
      });
    }
    print('hello');
  }

  void _getImage() async {
    final image = await ImagePicker().pickImage(source: _imageSource);
    if(image != null) {
      setState((){
        _imagePath = image.path;
      });
    }
  }

  void _saveMovie() {
    if(_selectedDate == null) {
      showMsg(context, 'Please select a date');
      return;
    }
    if(_imagePath == null) {
      showMsg(context, 'Please select an image');
      return;
    }
    if(_formKey.currentState!.validate()) {
      final movie = Movie(
        name: _nameController.text,
        subTitle: _subtitleController.text,
        details: _descriptionController.text,
        rating: double.parse(_ratingController.text),
        type: _type,
        releaseDate: _selectedDate!.millisecondsSinceEpoch,
        image: _imagePath,
      );
      DbHelper.insertNewMovie(movie)
          .catchError((error) {
        showMsg(context, 'Could not save');
        throw error;
      })
          .then((id) {
        Navigator.pop(context);
      });
    }
  }
}

void showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
