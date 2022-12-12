import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../models/episode_item.dart';
import '../models/movie_item.dart';
import '../models/season_item.dart';
import '../models/wcam/citylink_camera.dart';

class WcamApiProvider {

  /// ts.kg
  // final _elcatDio = Dio(BaseOptions(
  //   baseUrl: 'https://www.ts.kg',
  //   sendTimeout: requestTimeout.inMilliseconds,
  //   receiveTimeout: requestTimeout.inMilliseconds,
  //   headers: {
  //     'User-Agent': userAgent,
  //   },
  // ));

  static String getTextByClassName(Document document, String className) {
    final elements = document.getElementsByClassName(className);
    if (elements.isNotEmpty) {
      return elements.first.text.trim();
    }

    return '';
  }


  /// получение списка камер live.saimanet.kg
  Future<List<MovieItem>> getSaimaCameras() async {
    
    /// список элементов
    final items = <MovieItem>[];

    try {

      /// запрашиваем данные
      final response = await Dio().get('https://live.saimanet.kg');

      if (response.statusCode == 200) {
        /// ^ если запрос выполнен успешно
        
        /// парсим html
        final document = parse(response.data);

        /// получаем элементы списка камер
        final elements = document.getElementsByClassName('onemaincam');

        for (final element in elements) {
          /// парсим элемент iframe
          /*
            <div class="onemaincam mt">
              <div class="image">
                  <a href="/ru/cams/2"><img src="/images/cam2.jpg"
                                            alt=""
                                            title=""/></a>
                  <div class="playicon"><a href="/ru/cams/2"></a></div>
              </div>
              <div class="title"><a href="/ru/cams/2">Площадь Ала-Тоо</a></div>
            </div>
          */
          String name = '';
          String posterUrl = '';
          final img = element.getElementsByTagName('img');
          if (img.isNotEmpty) {
            String imgSrc = img.first.attributes['src'] ?? '';
            if (!imgSrc.startsWith('/')) {
              imgSrc = '/$imgSrc';
            }
            posterUrl = 'https://live.saimanet.kg$imgSrc';
          }

          final link = element.getElementsByClassName('title').first.getElementsByTagName('a');
          if (link.isNotEmpty) {
            name = link.first.text;
            final cameraId = link.first.attributes['href'] ?? '';
            final youtubeSrc = await getSaimaYoutueLink(cameraId);

            if (youtubeSrc.isNotEmpty) {
              items.add(
                MovieItem(
                  type: MovieItemType.wcam,
                  id: cameraId,
                  name: name,
                  posterUrl: posterUrl,
                  seasons: [
                    SeasonItem(
                      name: '',
                      episodes: [
                        EpisodeItem(
                          id: '',
                          name: '',
                          videoFileUrl: youtubeSrc,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }
        }
      }
    } catch (exception, stack) {
      /// ^ если прозошла сетевая ошибка
      
      debugPrint('exception: $exception');
    }

    return items;
  }

  Future<String> getSaimaYoutueLink(String url) async {
    try {

      /// запрашиваем данные
      final response = await Dio().get('https://live.saimanet.kg$url');
      if (response.statusCode == 200) {
        /// ^ если запрос выполнен успешно
        
        /// парсим html
        final document = parse(response.data);
        final iframe = document.getElementsByTagName('iframe').first;
        
        return iframe.attributes['src'] ?? '';
      }


    } catch (exception, stack) {
      /// ^ если прозошла сетевая ошибка
      
      debugPrint('exception: $exception');
    }

    return '';
  }


  /// получение списка камер elcat.kg
  Future<List<MovieItem>> getElcatCameras() async {
    
    /// список элементов
    final items = <MovieItem>[];

    try {

      /// запрашиваем данные
      final response = await Dio().get('https://elcat.kg/translation');

      if (response.statusCode == 200) {
        /// ^ если запрос выполнен успешно
        /// парсим html
        final document = parse(response.data);

        /// получаем элементы списка камер
        final elements = document.getElementsByClassName('stream_hide');

        return elements.map((element) {
          /// парсим элемент iframe
          /*
            <iframe width="560" height="315" src="//webcam.elcat.kg:5443/LiveApp/play.html?name=328712567719434766950272&autoplay=true" frameborder="0" allowfullscreen></iframe>
          */
          String streamName = '';
          final src = element.getElementsByTagName('iframe').first.attributes['src'];
          final uri = Uri.parse(src ?? '');
          if (uri.hasQuery) {
            streamName = uri.queryParameters['name'] ?? '';
          }


          /// парсим элемент с названием
          /*
            <div id="video_3" class="tranlation__item">
              <img src="https://elcat.kg/wp-content/uploads/2019/11/Въезд-в-Балыкчи.jpeg">
              <h2>Въезд в г. Балыкчи</h2>
              <span></span>
            </div>
          */
          final translation = element.nextElementSibling;
          final imageSrc = translation?.getElementsByTagName('img').first.attributes['src'] ?? '';
          final name = translation?.getElementsByTagName('h2').first.text ?? '';

          return MovieItem(
            type: MovieItemType.wcam,
            id: streamName,
            name: name,
            posterUrl: imageSrc,
            seasons: [
              SeasonItem(
                name: '',
                episodes: [
                  EpisodeItem(
                    id: '',
                    name: '',
                    videoFileUrl: 'https://webcam.elcat.kg:5443/LiveApp/streams/$streamName.m3u8?token=null'
                  ),
                ],
              ),
            ],
          );

        }).toList();

        

      }
    } catch (exception, stack) {
      /// ^ если прозошла сетевая ошибка
      
      debugPrint('exception: $exception');
    }

    return items;
  }

  Future<List<MovieItem>> getKtCameras() async {
    return [
      MovieItem(
        type: MovieItemType.wcam,
        id: '1',
        name: 'г. Бишкек (Чуй/Советская)',
        posterUrl: '',
        seasons: [
          SeasonItem(
            name: '',
            episodes: [
              EpisodeItem(
                id: '',
                name: '',
                videoFileUrl: 'http://213.145.131.243:80/cam1/stream.m3u8'
              ),
            ],
          ),
        ],
      ),
      MovieItem(
        type: MovieItemType.wcam,
        id: '2',
        name: 'с. Бостери',
        posterUrl: '',
        seasons: [
          SeasonItem(
            name: '',
            episodes: [
              EpisodeItem(
                id: '',
                name: '',
                videoFileUrl: 'http://213.145.131.243:80/cam2/stream.m3u8'
              ),
            ],
          ),
        ],
      ),
      MovieItem(
        type: MovieItemType.wcam,
        id: '3',
        name: 'г. Ош',
        posterUrl: '',
        seasons: [
          SeasonItem(
            name: '',
            episodes: [
              EpisodeItem(
                id: '',
                name: '',
                videoFileUrl: 'http://213.145.131.243:80/cam3/stream.m3u8'
              ),
            ],
          ),
        ],
      ),
      
      
    ];
  }


  /// получение количества доступных камер moidom.citylink.pro
  Future<int> getCitylinkTotalCount([ String city = '' ]) async {

    try {

      /// запрашиваем данные
      final response = await Dio().get('https://moidom.karelia.pro/api/',
        queryParameters: {
          'mode': 'getPublicCounters',
          'city': city,
        },
        options: Options( 
          responseType: ResponseType.plain,
        )
      );

      if (response.statusCode == 200) {
        /// ^ если запрос выполнен успешно
        
        return int.tryParse(response.data) ?? 0;
      }
    } catch (exception, stack) {
      /// ^ если прозошла сетевая ошибка
      
      debugPrint('exception: $exception');
    }

    return 0;
  }

  /// получение списка камер moidom.citylink.pro
  Future<List<MovieItem>> getCitylinkCameras({
    required int page,
    String city = '',
  }) async {

    // try {

      /// запрашиваем данные
      final response = await Dio().get('https://moidom.citylink.pro/api/',
      
        queryParameters: {
          'mode': 'getPublicCamsList',
          'page': '$page',
          'city': city,
        },
        options: Options( 
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        /// ^ если запрос выполнен успешно
        // final response = await _dio.post('', data: formData);

        final jsonResponse = json.decode(response.data);

        List<CitylinkCamera> cameras = jsonResponse.values.map<CitylinkCamera>((item) {
          return CitylinkCamera.fromJson(item);
        }).toList();

        return cameras.map<MovieItem>((camera) {
          return MovieItem(
            type: MovieItemType.wcam,
            id: '${camera.id}',
            name: camera.name,
            posterUrl: camera.img,
            seasons: [
              SeasonItem(
                name: '',
                episodes: [
                  EpisodeItem(
                    id: '',
                    name: '',
                    videoFileUrl: camera.src,
                  ),
                ],
              ),
            ],
          );
        }).toList();

      }
    // } catch (exception, stack) {
    //   /// ^ если прозошла сетевая ошибка
      
    //   debugPrint('exception: $exception');
    // }

    return [];
  }

}
