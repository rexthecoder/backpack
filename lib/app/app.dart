import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/l10n.dart';
import 'src/backend/authentication/authentication_bloc.dart';
import 'src/backend/repository/authentication_repository.dart';
import 'src/ui/global/router/router.gr.dart' as route;

class App extends StatelessWidget {
  const App({@required this.authRepository, Key key})
      : assert(authRepository != null,
            'Authentication Repository can not be null'),
        super(key: key);
  final AuthenticationRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationRepository>.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) =>
            AuthenticationBloc(authenticationRepository: authRepository)
              ..add(AppStarted()),
        child: const AppView(),
        // child: MaterialApp(
        //   debugShowCheckedModeBanner: false,

        //   onGenerateRoute: route.Router(),
        //   // restore the route or default to the home page
        // ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AuthenticationRepository>(
        'authRepository', authRepository));
  }
}

class AppView extends StatefulWidget {
  const AppView({Key key}) : super(key: key);
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: GestureDetector(
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          onGenerateRoute: route.Router(),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushReplacementNamed('/dashboard-view');
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushReplacementNamed('/splash-view');
                    break;
                  default:
                    break;
                }
              },
              child: child,
            );
          },
        ),
      ),
    );
  }
}
