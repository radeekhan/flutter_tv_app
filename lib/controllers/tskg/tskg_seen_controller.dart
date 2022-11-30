import 'package:hive_flutter/hive_flutter.dart';
import 'package:kgino/models/tskg/tskg_seen_episode.dart';

import '../../models/tskg/tskg_episode.dart';
import '../../models/tskg/tskg_favorite.dart';

class TskgSeenController {
  /// ключ для сохранённого значения
  static const boxName = 'tskg_seen';

  /// хранилище данных
  final box = Hive.box<TskgSeenEpisode>(boxName);

  TskgSeenController();

  // /// добавляем сериал в избранное
  // void add(TskgEpisode episode) {

  //   final favorite = TskgFavorite(
  //     showId: show.showId,
  //     name: show.name,
  //     episodeCount: episodeCount,
  //     createdAt: DateTime.now(),
  //   );
    
  //   /// сохраняем значение на диск
  //   box.put(show.showId, favorite);
  // }

  // /// удаляем сериал из избранного
  // void remove(String showId) {
  //   box.delete(showId);
  // }

}
