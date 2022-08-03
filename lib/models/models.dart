const String tblMovie = 'tbl_movie';
const String tblMovieColId = 'id';
const String tblMovieColName = 'name';
const String tblMovieColSubtitle = 'subtitle';
const String tblMovieColDescription = 'description';
const String tblMovieColType = 'type';
const String tblMovieColImage = 'image';
const String tblMovieColDate = 'date';
const String tblMovieColRating = 'rating';
class Movie{
  int? id;
  String? name;
  String? subTitle;
  String? details;
  String? type;
  String? image;
  double? rating;
  int? releaseDate;
  Movie(
      {this.id,
        this.name,
        this.subTitle,
        this.details,
        this.type,
        this.image,
        this.rating,
        this.releaseDate});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tblMovieColName : name,
      tblMovieColSubtitle : subTitle,
      tblMovieColType : type,
      tblMovieColDescription : details,
      tblMovieColImage : image,
      tblMovieColRating : rating,
      tblMovieColDate : releaseDate
    };
    if(id != null) {
      map[tblMovieColId] = id;
    }
    return map;
  }

  factory Movie.fromMap(Map<String, dynamic> map) => Movie(
    id: map[tblMovieColId],
    name: map[tblMovieColName],
    subTitle: map[tblMovieColSubtitle],
    details: map[tblMovieColDescription],
    type: map[tblMovieColType],
    releaseDate: map[tblMovieColDate],
    image: map[tblMovieColImage],
    rating: map[tblMovieColRating],
  );
}