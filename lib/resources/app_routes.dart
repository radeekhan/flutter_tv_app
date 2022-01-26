import 'package:get/get.dart';
import 'package:kgino/pages/home_page.dart';
import 'package:kgino/pages/player_page.dart';
import 'package:kgino/pages/show_page.dart';
import 'package:kgino/pages/unknown_route_page.dart';

class AppRoutes {

  static const initial = '/';

  static const unknown = '/404';


  static get unknownRoute => GetPage(
    name: unknown,
    page: () => const UnknownRoutePage()
  );
  

  /// карта маршрутов
  static final routes = [

    /// домашнаяя страница
    GetPage(
      name: initial,
      page: () {
        return const HomePage();
      },
    ),

    /// страница сериала (сезоны и эпизоды)
    GetPage(
      name: '/tskg/show/:id',
      page: () {
        /// id запрашиваемого сериала
        final showId = Get.parameters['id'] ?? '';

        return ShowPage(
          id: showId
        );
      },
    ),

    /// страница плеера
    GetPage(
      name: '/player',
      page: () {
        /// id запрашиваемого сериала
        //final showId = Get.parameters['id'] ?? '';

        return const PlayerPage(
          //id: showId
        );
      },
    ),

  ];

}
