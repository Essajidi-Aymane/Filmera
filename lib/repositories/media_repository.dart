import '../services/tmdb_api.dart'; 
import '../models/media_item.dart';

class MediaRepository { 

  final TmdbApi api ; 

MediaRepository({required this.api}) ; 


Future<List<MediaItem>> getSuggestions() async {
  final list = await api.getTrending();
  return list 
       .where((json) => 
       json['media_type'] == 'movie' || json['media_type'] == 'tv' )
       .map<MediaItem>((json) {
        if (json['media_type'] == 'movie') {
          return MediaItem.fromMovieJson(json);
        } else {
          return MediaItem.fromTvJson(json);  
       }  
    }).toList(); 
  }


  Future<List<MediaItem>> search(String query) async {
    final list = await api.search(query) ; 
    return list .where((json) => 
       json['media_type'] == 'movie' || json['media_type'] == 'tv' )
       .map<MediaItem>((json) {
        if (json['media_type'] == 'movie') {
          return MediaItem.fromMovieJson(json);
        } else {
          return MediaItem.fromTvJson(json);  
       }  
    }).toList();
  }

  Future<MediaItem> getDetails( MediaItem item ) async {
    final json = await api.getDetails(item.id, item.isMovie); 
    return item.isMovie ? MediaItem.fromMovieJson(json) : MediaItem.fromTvJson(json) ;
  }
}