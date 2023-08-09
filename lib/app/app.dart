import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../ui/navigation/navigation.dart';
import '../ui/themes/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      builder: (context, child) {
        return MaterialApp(
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: context.select((ProfileProvider provider) {
            return provider.theme;
          }),
          initialRoute: Navigation.initialRoute,
          onGenerateRoute: Navigation.onGenerateRoute,
          locale: context.select((ProfileProvider provider) {
            return provider.locale;
          }),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', ''),
            Locale('en', ''),
            Locale('ko', ''),
          ],
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
