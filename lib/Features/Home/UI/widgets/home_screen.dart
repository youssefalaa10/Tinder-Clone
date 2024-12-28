import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder/Features/Home/UI/widgets/tinder_card.dart';

import '../../Logic/card_provider.dart';
// import '../../Model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// final List<UserModel> users = [
//   const UserModel(
//     name: 'John Doe',
//     age: 25,
//     urlImage:
//         'https://plus.unsplash.com/premium_photo-1661580574627-9211124e5c3f?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     liveLocation: 'New York',
//     miles: '2',
//   ),
//   const UserModel(
//     name: 'John Doe',
//     age: 25,
//     urlImage:
//         'https://plus.unsplash.com/premium_photo-1661766718556-13c2efac1388?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGRvY3RvcnxlbnwwfHwwfHx8MA%3D%3D',
//     liveLocation: 'New York',
//     miles: '2',
//   ),
// ];

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
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
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
    return const Center(
      child: Icon(Icons.local_fire_department_rounded,
          color: Colors.red, size: 40),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return users.isEmpty
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);
              provider.resetUsers();
            },
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.black),
            ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.red, Colors.white, isDislike),
                  backgroundColor:
                      getColor(Colors.white, Colors.red, isDislike),
                  side: getBorder(Colors.red, Colors.white, isDislike),
                ),
                onPressed: () {
                  final provider = Provider.of<CardProvider>(context);
                  provider.dislike();
                },
                child: const Icon(Icons.clear, size: 40),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.blue, Colors.white, isSuperLike),
                  backgroundColor:
                      getColor(Colors.white, Colors.blue, isSuperLike),
                  side: getBorder(Colors.blue, Colors.white, isSuperLike),
                ),
                onPressed: () {
                  final provider = Provider.of<CardProvider>(context);
                  provider.superLike();
                },
                child: const Icon(Icons.star, size: 40),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: getColor(Colors.green, Colors.white, isLike),
                  backgroundColor: getColor(Colors.white, Colors.green, isLike),
                  side: getBorder(Colors.green, Colors.white, isLike),
                ),
                onPressed: () {
                  final provider = Provider.of<CardProvider>(context);
                  provider.like();
                },
                child: const Icon(Icons.favorite, size: 40),
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
