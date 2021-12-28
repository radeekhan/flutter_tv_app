class TskgItem {
  final DateTime date;
  final String badge;
  final String title;
  final String subtitle;
  final String genres;
  final String link;
  late final String tvshowId;
  
  TskgItem({
    required this.date,
    this.badge = '',
    this.title = '',
    this.subtitle = '',
    this.genres = '',
    this.link = '',
  }) {
    /// разделяем url по '/'
    final path = link.split('/');
    
    if (link.startsWith('/show') && path.length > 1) {
      /// ^ если url похож на ссылку сериала
      
      /// идентификатор сериала должен быть третьим элементом в массиве
      tvshowId = path.elementAt(2);

    } else {
      /// ^ если url странный
      
      tvshowId = '';
    }
  }

  /// cсылка на постер сериала
  String get poster => 'https://www.ts.kg/posters/$tvshowId.png';

  /// cсылка на постер сериала
  String get tvshowUrl => 'https://www.ts.kg/show/$tvshowId.png';
}