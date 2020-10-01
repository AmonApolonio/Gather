import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_event.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/matches.dart';
import 'package:gather_app/ui/pages/messages.dart';
import 'package:gather_app/ui/pages/search.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';

class Tabs extends StatelessWidget {
  final userId;

  Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Matches(
        userId: userId,
      ),
      Search(
        userId: userId,
      ),
      Messages(
        userId: userId,
      ),
    ];

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "GATHER",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Clobber',
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: <Widget>[
            //!! TROCAR BOTÃO DE LUGAR
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            ),
            //!!
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Theme(
              data: ThemeData(
                splashColor: mainColor,
                highlightColor: mainColor,
                accentColor: Colors.white,
              ),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(
                            GatherCustomIcons.profile,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            GatherCustomIcons.gather,
                            size: 35,
                          ),
                        ),
                        Tab(
                          icon: Icon(GatherCustomIcons.chat),
                        ),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: backgroundColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: pages,
        ),
      ),
    );
  }
}