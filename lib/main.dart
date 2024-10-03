import 'package:bearlysocial/providers/auth_details/auth_state.dart';
import 'package:bearlysocial/providers/net_info/net_state.dart';
import 'package:bearlysocial/themes.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:bearlysocial/utils/motion_utils.dart';
import 'package:bearlysocial/utils/settings_utils.dart';
import 'package:bearlysocial/views/pages/auth_page.dart';
import 'package:bearlysocial/views/pages/loading_page.dart';
import 'package:bearlysocial/views/pages/session_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabaseUtility.createConnection();
  await EasyLocalization.ensureInitialized();

  runApp(const AppSetup());
}

class AppSetup extends StatelessWidget {
  const AppSetup({super.key});

  @override
  Widget build(BuildContext context) {
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    ref.read(storeNetworkInfo)().then((_) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
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
      scrollBehavior: const BouncingScroll(),
    );
  }
}
