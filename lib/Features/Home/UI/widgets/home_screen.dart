import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder/Core/Managers/image_manager.dart';
import 'package:tinder/Features/Home/UI/widgets/tinder_card.dart';

import '../../Logic/card_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(),
                const SizedBox(height: 16),
                Expanded(child: buildCards()),
                const SizedBox(height: 16),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: ElevatedButton(
                onPressed: () {
                  provider.resetUsers();
                },
                child: const Text('Restart')),
          )
        : Stack(
            children: users
                .map((user) => TinderCard(
                      user: user,
                      isFront: users.last == user,
                    ))
                .toList(),
          );
  }

  Widget buildLogo() {
    return Center(
      child: Image.asset(
        ImageManager.tinderLogo,
        width: 30.45,
      ),
    );
  }
Widget buildButtons() {
  final provider = Provider.of<CardProvider>(context);
  final status = provider.getStatus();
  final isLike = status == CardStatus.like;
  final isDislike = status == CardStatus.dislike;
  final isSuperLike = status == CardStatus.superLike;

  return provider.users.isEmpty
      ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            provider.resetUsers();
          },
          child: const Text(
            'Restart',
            style: TextStyle(color: Colors.black),
          ),
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Dislike Button
            Container(
              width: 62,
              height: 62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: isDislike ? Colors.white : Colors.red,
                  backgroundColor: isDislike ? Colors.red : Colors.white,
                  shape: const CircleBorder(),
                  side: BorderSide(
                    color: isDislike ? Colors.transparent : Colors.red,
                    width: 2,
                  ),
                ),
                onPressed: () {
                  provider.dislike();
                },
                child: Center(
                  child: SizedBox.expand(
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 40,
                        color: isDislike ? Colors.white : Colors.red,
                      ),
                      onPressed: null,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            // SuperLike Button
            Container(
              width: 42,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: isSuperLike ? Colors.white : Colors.blue,
                  backgroundColor: isSuperLike ? Colors.blue : Colors.white,
                  shape: const CircleBorder(),
                  side: BorderSide(
                    color: isSuperLike ? Colors.transparent : Colors.blue,
                    width: 2,
                  ),
                ),
                onPressed: () {
                  provider.superLike();
                },
                child: Center(
                  child: SizedBox.expand(
                    child: IconButton(
                      icon: Icon(
                        Icons.star,
                        size: 28,
                        color: isSuperLike ? Colors.white : Colors.blue,
                      ),
                      onPressed: null,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            // Like Button
            Container(
              width: 62,
              height: 62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: isLike ? Colors.white : Colors.green,
                  backgroundColor: isLike ? Colors.green : Colors.white,
                  shape: const CircleBorder(),
                  side: BorderSide(
                    color: isLike ? Colors.transparent : Colors.green,
                    width: 2,
                  ),
                ),
                onPressed: () {
                  provider.like();
                },
                child: Center(
                  child: SizedBox.expand(
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: 40,
                        color: isLike ? Colors.white : Colors.green,
                      ),
                      onPressed: null,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
}
  WidgetStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    getColor(Set<WidgetState> states) {
      if (force || states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return WidgetStateProperty.resolveWith(getColor);
  }

  WidgetStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    getBorder(Set<WidgetState> states) {
      if (force || states.contains(WidgetState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    }

    return WidgetStateProperty.resolveWith(getBorder);
  }
}
