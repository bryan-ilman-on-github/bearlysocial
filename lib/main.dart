import 'package:bearlysocial/providers/auth_details/auth_state.dart';
import 'package:bearlysocial/themes.dart';
import 'package:bearlysocial/utilities/db_operation.dart';
import 'package:bearlysocial/utilities/inline_translation_loader.dart';
import 'package:bearlysocial/views/pages/auth_page.dart';
import 'package:bearlysocial/views/pages/loading_page.dart';
import 'package:bearlysocial/views/pages/session_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseOperation.createConnection();

  await EasyLocalization.ensureInitialized();

  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/l10n',
        fallbackLocale: const Locale('en'),
        assetLoader: TranslationLoader(),
        child: const App(),
      ),
    );
  }
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    ref.read(validateToken)().then((_) => setState(() => _loading = false));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
    ));

    return MaterialApp(
      title: 'BearlySocial',
      theme: createTheme(lightMode: true),
      darkTheme: createTheme(lightMode: false),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: _loading
          ? const LoadingPage()
          : ref.watch(auth)
              ? const SessionPage()
              : const AuthPage(),
      scrollBehavior: const _BouncingScroll(),
    );
  }
}

class _BouncingScroll extends ScrollBehavior {
  const _BouncingScroll();

  @override
  ScrollPhysics getScrollPhysics(_) => const BouncingScrollPhysics();
}
