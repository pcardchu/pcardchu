import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/card_list_provider.dart';
import 'package:frontend/home/models/card_info_model.dart';
import 'package:frontend/card/widgets/example_card.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MyRegisterCard extends StatefulWidget {
  const MyRegisterCard({Key? key}) : super(key: key);

  @override
  State<MyRegisterCard> createState() => _MyRegisterCardState();
}

class _MyRegisterCardState extends State<MyRegisterCard> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // CardListProvider를 가져와서 getUserCardsList 메소드를 호출합니다.
      final cardListProvider = Provider.of<CardListProvider>(context, listen: false);
      cardListProvider.getUserCardsList();
    });

  }
  @override
  Widget build(BuildContext context) {
    final cardListProvider = Provider.of<CardListProvider>(context);
    final cards = cardListProvider.cardList
        .map((cardInfo) => ExampleCard(model: cardInfo))
        .toList();


    final int numberOfCardsToShow = min(cards.length, 3);

    return Container(
      height: ScreenUtil.h(56),
      padding: EdgeInsets.symmetric(vertical: 40),
      child: cards.isNotEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CardSwiper(
              controller: controller,
              cardsCount: cards.length,
              onSwipe: _onSwipe,
              onUndo: _onUndo,
              numberOfCardsDisplayed: numberOfCardsToShow,
              allowedSwipeDirection: AllowedSwipeDirection.only(down: true),
              backCardOffset: const Offset(0, -60),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) => cards[index],
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()), // 또는 "등록된 카드가 없습니다" 텍스트 표시
    );
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    debugPrint('The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top');
    return true;
  }

  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    debugPrint('The card $currentIndex was undod from the ${direction.name}');
    return true;
  }
}
