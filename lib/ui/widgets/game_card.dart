import 'package:flutter/material.dart';

import '../constants.dart';

Widget gameCard(game, size) {
  return Container(
    width: (size.width * 0.8) / 3,
    height: 100,
    child: Image.network(
      'https://firebasestorage.googleapis.com/v0/b/gather-81171.appspot.com/o/games%2F' +
          game +
          '%2F' +
          game +
          '.png?alt=media&token=10840b42-3dad-4924-a43d-7d65fe9e0050',
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(mainColor),
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    ),
  );
}
