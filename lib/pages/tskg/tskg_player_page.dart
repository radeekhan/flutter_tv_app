import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../api/tskg_api_provider.dart';
import '../../controllers/seen_items_controller.dart';
import '../../models/playable_item.dart';
import '../../models/seen_item.dart';
import '../../models/tskg/tskg_episode.dart';
import '../../models/tskg/tskg_show.dart';
import '../../ui/video_player/video_player_view.dart';

class TskgPlayerPage extends StatefulWidget {
  final int episodeIndex;
  final String episodeId;
  final TskgShow show;

  const TskgPlayerPage({
    super.key,
    required this.show,
    this.episodeId = '',
    this.episodeIndex = 0,
  });

  @override
  State<TskgPlayerPage> createState() => _TskgPlayerPageState();
}

class _TskgPlayerPageState extends State<TskgPlayerPage> {
  final _episodes = <TskgEpisode>[];
  late final int _episodeCount;
  int _currentIndex = 0;
  bool _subtitlesEnabled = false;
  int _startTime = 0;

  @override
  void initState() {
    _currentIndex = widget.episodeIndex;

    /// все эпизоды в одном списке
    for (final season in widget.show.seasons) {
      _episodes.addAll(season.episodes);
    }

    /// количество эпизодов во всех сезонах
    _episodeCount = widget.show.seasons.fold(0, (previousValue, season) {
      return previousValue + season.episodes.length;
    });

    /// контроллер просмотренных эпизодов
    final seenItemsController = GetIt.instance<SeenItemsController>();
    
    /// проверяем был ли сериал уже в просмотренных
    final seenShow = seenItemsController.findItemByKey(
      SeenItem.getKey(
        tag: SeenItem.tskgTag,
        id: widget.show.showId,
      )
    );
    
    if (seenShow != null) {
      /// ^ если сериал уже был в просмотренных
      
      /// восстонавливаем состояние субтитров (включены или выключены)
      _subtitlesEnabled = seenShow.subtitlesEnabled;
      
      /// проверяем был ли эпизод в просмотренных
      final seenEpisode = seenItemsController.findEpisode(
        tag: SeenItem.tskgTag,
        itemId: widget.show.showId,
        episodeId: widget.episodeId,
      );

      if (seenEpisode != null) {
        /// ^ если эпизод уже был в просмотренных
        
        /// восстанавливаем время просмотра
        _startTime = seenEpisode.position;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// контроллер просмотренных эпизодов
    final seenEpisodesController = GetIt.instance<SeenItemsController>();

    return VideoPlayerView(
      onInitialPlayableItem: _getPlayableItem,

      onSkipNext: (_currentIndex + 1 < _episodeCount) ? () {
        /// переходим к следующему файлу
        setState(() {
          _startTime = 0;
          _currentIndex++;
        });

        return _getPlayableItem();
      } : null,

      onSkipPrevious: (_currentIndex > 0) ? () {
        /// переходим к предыдущему файлу
        setState(() {
          _startTime = 0;
          _currentIndex--;
        });

        return _getPlayableItem();
      } : null,

      onUpdatePosition: (episodeId, position, duration, subtitlesEnabled, episodeName) {
        _subtitlesEnabled = subtitlesEnabled;

        seenEpisodesController.updatePosition(
          tag: SeenItem.tskgTag,
          parentId: widget.show.showId,
          episodeId: episodeId,
          name: widget.show.name,
          position: position,
          duration: duration,
          subtitlesEnabled: _subtitlesEnabled,
          episodeName: episodeName,
        );
      }
    );
  }

  Future<PlayableItem> _getPlayableItem() async {
    
    final currentEpisode = _episodes[_currentIndex];
    
    /// провайдер запросов к API
    final api = GetIt.instance<TskgApiProvider>();
    
    /// получаем данные эпизода
    final episode = await api.getEpisodeDetails(currentEpisode.id);

    /// качество видео по умолчанию - SD
    String videoUrl = episode?.video.files.sd.url ?? '';
    
    /// субтитры
    String subtitleUrl = episode?.video.subtitles ?? '';
    
    if (episode != null) {
      if (episode.video.files.hd.url.isNotEmpty) {
        /// ^ если есть видео в HD качестве
        
        /// задаём качество видео HD
        videoUrl = episode.video.files.hd.url;
      }
    }
    
    String subtitle = '${episode?.name}';

    return PlayableItem(
      id: '${episode?.id}',
      videoUrl: videoUrl,
      subtitleUrl: subtitleUrl,
      title: widget.show.name,
      subtitle: subtitle,
      subtitlesEnabled: _subtitlesEnabled,
      startTime: _startTime,
    );
  }

}
