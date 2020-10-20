import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_event.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/about_tab.dart';
import 'package:gather_app/ui/pages/search.dart';
import 'package:gather_app/ui/pages/social_screen.dart';

class Tabs extends StatelessWidget {
  final _userRepository;
  final userId;

  Tabs({@required UserRepository userRepository, String userId})
      : assert(userRepository != null && userId != null),
        _userRepository = userRepository,
        userId = userId;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      AboutTab(
        userRepository: _userRepository,
        targetUserId: userId,
        currentUserId: userId,
      ),
      Search(
        userId: userId,
      ),
      Social(
        userId: userId,
      )
      // Messages(
      //   userId: userId,
      // ),
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
            //TODO: TROCAR BOTÃO DE LUGAR
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            ),
            //!!
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(35.0),
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
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
