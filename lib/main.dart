import 'dart:async';

import 'package:bearlysocial/internet.dart';
import 'package:bearlysocial/providers/flags_pod.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:bearlysocial/utils/motion_util.dart';
import 'package:bearlysocial/utils/settings_util.dart';
import 'package:bearlysocial/utils/theme_util.dart';
import 'package:bearlysocial/views/pages/auth_page.dart';
import 'package:bearlysocial/views/pages/loading_page.dart';
import 'package:bearlysocial/views/pages/session_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabaseUtility.createConnection();
  await EasyLocalization.ensureInitialized();

  runApp(const AppSetup());
}

class AppSetup extends StatelessWidget {
  const AppSetup({super.key});

  @override
  Widget build(context) {
    return ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
          Locale('de'),
          Locale('fr'),
        ],
        path: 'assets/l10n',
        fallbackLocale: const Locale('en'),
        assetLoader: TranslationLoader(),
        child: const AppEntry(),
      ),
    );
  }
}

class AppEntry extends ConsumerStatefulWidget {
  const AppEntry({Key? key}) : super(key: key);

  @override
  ConsumerState<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<AppEntry> {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  bool isInternetConnected = true;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (!isConnected) {
        InternetBannerOverlay.showBanner();
      } else {
        InternetBannerOverlay.hideBanner();
      }
    });
  }

  @override
  dispose() {
    subscription?.cancel();
    InternetBannerOverlay.hideBanner(); // Clean up the banner
    super.dispose();
  }

  @override
  Widget build(context) {
    return MaterialApp(
        title: 'BearlySocial',
        theme: ThemeUtility.createTheme(),
        darkTheme: ThemeUtility.createTheme(dark: true),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: _loading
            ? const LoadingPage()
            : !ref.watch(isAuthenticated)
                ? const SessionPage()
                : const AuthPage(),
        scrollBehavior: const BouncingScroll(),
        navigatorKey: InternetBannerOverlay.navigatorKey);
  }
}
