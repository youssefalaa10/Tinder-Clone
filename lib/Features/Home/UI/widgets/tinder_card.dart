import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder/Features/Home/Model/user_model.dart';

import '../../Logic/card_provider.dart';

class TinderCard extends StatefulWidget {
  final UserModel user;
  // final String urlImage;
  final bool isFront;
  const TinderCard({super.key, required this.user, required this.isFront});

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  // front of the card
  Widget buildFrontCard() {
    return GestureDetector(
      child: LayoutBuilder(builder: (context, constraints) {
        final provider = Provider.of<CardProvider>(context);
        final position = provider.position;
        final milliseconds = provider.isDragging ? 0 : 400;
        final center = constraints.smallest.center(Offset.zero);
        final angle = provider.angle * pi / 180;
        final rotatedMatrix = Matrix4.identity()
          ..translate(center.dx, center.dy)
          ..rotateZ(angle)
          ..translate(-center.dx, -center.dy);
        return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix
              ..translate(
                position.dx,
                position.dy,
              ),
            child: Stack(
              children: [
                buildCard(),
                buildStamps(),
              ],
            ));
      }),
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.endPosition();
      },
    );
  }

// card
  Widget buildCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.user.urlImage),
            fit: BoxFit.cover,
            alignment: const Alignment(-0.3, 0),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
              stops: [0.7, 1],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                buildName(),
                const SizedBox(height: 8),
                buildLiveLocation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Stamps
  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            angle: -0.5, color: Colors.green, text: 'LIKE', opacity: opacity);
        return Positioned(top: 64, left: 50, child: child);

      case CardStatus.dislike:
        final child = buildStamp(
            angle: 0.5, color: Colors.red, text: 'DISLIKE', opacity: opacity);
        return Positioned(
          top: 64,
          right: 50,
          child: child,
        );
      case CardStatus.superLike:
        final child = Center(
          child: buildStamp(
              color: Colors.blue, text: 'SUPER\n LIKE', opacity: opacity),
        );

        return Positioned(bottom: 128, right: 0, left: 0, child: child);
      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

//  name & age
  Widget buildName() {
    return Row(
      children: [
        Text(
          '${widget.user.name},',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          widget.user.age.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  // live location
  Widget buildLiveLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live in ${widget.user.liveLocation}',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.user.miles} miles away',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
