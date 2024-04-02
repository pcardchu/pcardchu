import 'package:flutter/material.dart';
import 'package:frontend/utils/screen_util.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:frontend/card/models/example_candidate_model.dart';
import 'package:frontend/card/widgets/example_card.dart';

class MyRegisterCard extends StatefulWidget {
  const MyRegisterCard({super.key});

  @override
  State<MyRegisterCard> createState() => _MyRegisterCardState();
}

class _MyRegisterCardState extends State<MyRegisterCard> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map(ExampleCard.new).toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.h(56),
      //color: Colors.red,
      padding: EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CardSwiper(
              controller: controller,
              cardsCount: cards.length,
              onSwipe: _onSwipe,
              onUndo: _onUndo,
              numberOfCardsDisplayed: 2,
              allowedSwipeDirection: AllowedSwipeDirection.only(down: true),
              backCardOffset: const Offset(0, -60),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              cardBuilder: (
                context,
                index,
                horizontalThresholdPercentage,
                verticalThresholdPercentage,
              ) =>
                  cards[index],
            ),
          ),
        ],
      ),
    );
  }
}

bool _onSwipe(
  int previousIndex,
  int? currentIndex,
  CardSwiperDirection direction,
) {
  debugPrint(
    'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
  );
  return true;
}

bool _onUndo(
  int? previousIndex,
  int currentIndex,
  CardSwiperDirection direction,
) {
  debugPrint(
    'The card $currentIndex was undod from the ${direction.name}',
  );
  return true;
}
