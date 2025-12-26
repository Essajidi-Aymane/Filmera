class MediaItem {

  final int id ; 
  final String title ;
  final String? posterPath ;
  final bool isMovie ;
  final double voteAverage ;
  final String overview ;
  

  MediaItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.isMovie,
    required this.voteAverage,
    required this.overview,
  });




  String? get posterUrl => posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null ;

  factory MediaItem.fromMovieJson(Map<String, dynamic> json) { 
    return MediaItem(id: json['id'], title: json['title']?? '', posterPath: json['poster_path'], isMovie: true, voteAverage: (json['vote_average']?? 0).toDouble() 
    , overview: json['overview'] ?? '' );
  }

  factory MediaItem.fromTvJson(Map<String, dynamic> json) { 
    return MediaItem(id: json['id'], title: json['name']?? '', posterPath: json['poster_path'], isMovie: false, voteAverage: (json['vote_average']?? 0).toDouble() 
    , overview: json['overview'] ?? '' );
  }

}