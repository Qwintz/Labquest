import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import '../components/bottom_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totalTaskCount = context.select((ProfileProvider provider) {
      return provider.totalTaskCount;
    });
    var completedTaskCount = context.select((ProfileProvider provider) {
      return provider.completedTaskCount;
    });
    context.read<ProfileProvider>().loadStats();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profilePageTitle),
        leading: IconButton(
          icon: const Icon(FluentIcons.chevron_left_24_filled),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.statisticsTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8.0),
            ListTile(
              title: Text(AppLocalizations.of(context)!.totalTasks),
              leading: const Icon(FluentIcons.status_24_filled),
              minLeadingWidth: 24.0,
              trailing: Text("$totalTaskCount"),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.completedTasks),
              leading: const Icon(FluentIcons.status_24_filled),
              minLeadingWidth: 24.0,
              trailing: Text("$completedTaskCount"),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.uncompletedTasks),
              leading: const Icon(FluentIcons.status_24_filled),
              minLeadingWidth: 24.0,
              trailing: Text("${totalTaskCount - completedTaskCount}"),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.settingsTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8.0),
            ListTile(
              title: Text(AppLocalizations.of(context)!.themeSettings),
              subtitle:
                  Text(context.read<ProfileProvider>().themeName(context)),
              leading: const Icon(FluentIcons.color_24_filled),
              minLeadingWidth: 24.0,
              onTap: () {
                openBottomSheet(
                  context: context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ThemeMode.values.map((theme) {
                      return ListTile(
                        title: Text(context
                            .read<ProfileProvider>()
                            .themeName(context, themeMode: theme)),
                        trailing: context.read<ProfileProvider>().theme.index ==
                                theme.index
                            ? const Icon(FluentIcons.checkmark_24_filled)
                            : null,
                        onTap: () {
                          context.read<ProfileProvider>().changeTheme(theme);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.languageSettings),
              subtitle:
                  Text(context.read<ProfileProvider>().localeName(context)),
              leading: const Icon(FluentIcons.earth_24_filled),
              minLeadingWidth: 24.0,
              onTap: () {
                openBottomSheet(
                  context: context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: AppLocalizations.supportedLocales.map((locale) {
                      return ListTile(
                        title: Text(context
                            .read<ProfileProvider>()
                            .localeName(context, locale: locale)),
                        trailing: context
                                    .read<ProfileProvider>()
                                    .locale
                                    .languageCode ==
                                locale.languageCode
                            ? const Icon(FluentIcons.checkmark_24_filled)
                            : null,
                        onTap: () {
                          context.read<ProfileProvider>().changeLocale(locale);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
