import 'package:flutter/material.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/widgets/elo_card.dart';

typedef void DynamicCallback(dynamic elo);

class EloDialog extends StatelessWidget {
  final DynamicCallback onEloChanged;

  const EloDialog({@required this.onEloChanged});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: backgroundColor,
        height: 350,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              color: mainColor,
              child: Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      GatherCustomIcons.cancel,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Select your skill level",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Clobber',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: size.width - 52,
              height: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: eloCard("LOW", size),
                        onTap: () {
                          onEloChanged("LOW");
                          Navigator.of(context).pop();
                        },
                      ),
                      GestureDetector(
                        child: eloCard("AVERAGE", size),
                        onTap: () {
                          onEloChanged("AVERAGE");
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: eloCard("HIGH", size),
                        onTap: () {
                          onEloChanged("HIGH");
                          Navigator.of(context).pop();
                        },
                      ),
                      GestureDetector(
                        child: eloCard("PRO", size),
                        onTap: () {
                          onEloChanged("PRO");
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
