import 'package:flutter/material.dart';
import 'package:kgino/resources/app_theme.dart';

class TskgSlider extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const TskgSlider({
    Key? key,
    this.title = '',
    this.items = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollController = ScrollController();
    
    /// слайдер
    Widget child = SizedBox(
      height: AppTheme.sliderCardSize,
      child: RawScrollbar(
        thumbColor: Colors.redAccent,
        isAlwaysShown: true,
        controller: scrollController,
        thickness: 1.0,
        radius: const Radius.circular(2.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            children: items,
            clipBehavior: Clip.none,
          ),
        ),
      ),
    );
  
    if (title.isNotEmpty) {
      /// ^ если был передан заголовок
      
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: theme.textTheme.headline6,
          ),
          child,
        ],
      );
    }


    return child;
  }
}