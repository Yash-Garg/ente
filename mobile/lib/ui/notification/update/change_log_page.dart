import "dart:async";
import "dart:io";

import 'package:flutter/material.dart';
import "package:photos/generated/l10n.dart";
import 'package:photos/services/update_service.dart';
import 'package:photos/theme/ente_theme.dart';
import 'package:photos/ui/components/buttons/button_widget.dart';
import 'package:photos/ui/components/divider_widget.dart';
import 'package:photos/ui/components/models/button_type.dart';
import 'package:photos/ui/components/title_bar_title_widget.dart';
import 'package:photos/ui/notification/update/change_log_entry.dart';
import "package:url_launcher/url_launcher_string.dart";

class ChangeLogPage extends StatefulWidget {
  const ChangeLogPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeLogPage> createState() => _ChangeLogPageState();
}

class _ChangeLogPageState extends State<ChangeLogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final enteColorScheme = getEnteColorScheme(context);
    return Scaffold(
      appBar: null,
      body: Container(
        color: enteColorScheme.backgroundElevated,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 36,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TitleBarTitleWidget(
                  title: "What's new",
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(child: _getChangeLog()),
            const DividerWidget(
              dividerType: DividerType.solid,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 16,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ButtonWidget(
                      buttonType: ButtonType.trailingIconPrimary,
                      buttonSize: ButtonSize.large,
                      labelText: S.of(context).continueLabel,
                      icon: Icons.arrow_forward_outlined,
                      onTap: () async {
                        await UpdateService.instance.hideChangeLog();
                        if (mounted && Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ButtonWidget(
                      buttonType: ButtonType.trailingIconSecondary,
                      buttonSize: ButtonSize.large,
                      // labelText: S.of(context).joinDiscord,
                      labelText: "Why we open sourced",
                      // icon: Icons.discord_outlined,
                      icon: Icons.rocket_rounded,
                      iconColor: enteColorScheme.primary500,
                      onTap: () async {
                        // unawaited(
                        //   launchUrlString(
                        //     "https://discord.com/invite/z2YVKkycX3",
                        //     mode: LaunchMode.externalApplication,
                        //   ),
                        // );
                        unawaited(
                          launchUrlString(
                            "https://ente.io/blog/open-sourcing-our-server/",
                            mode: LaunchMode.inAppBrowserView,
                          ),
                        );
                      },
                    ),
                    // ButtonWidget(
                    //   buttonType: ButtonType.trailingIconSecondary,
                    //   buttonSize: ButtonSize.large,
                    //   labelText: S.of(context).rateTheApp,
                    //   icon: Icons.favorite_rounded,
                    //   iconColor: enteColorScheme.primary500,
                    //   onTap: () async {
                    //     await UpdateService.instance.launchReviewUrl();
                    //   },
                    // ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChangeLog() {
    final scrollController = ScrollController();
    final List<ChangeLogEntry> items = [];
    if (Platform.isAndroid) {
      items.add(
        ChangeLogEntry(
          "Home Widget ✨",
          'Introducing our new Android widget! Enjoy your favourite memories directly on your home screen.',
        ),
      );
    }
    items.addAll([
      ChangeLogEntry(
        "Redesigned Discovery Tab",
        'We\'ve given it a fresh new look for improved design and better visual separation between each section.',
      ),
      ChangeLogEntry(
        "Location Clustering ",
        'Now, see photos automatically organize into clusters around a radius of populated cities.',
      ),
      ChangeLogEntry(
        "Ente is now fully Open Source!",
        'We took the final step in our open source journey.\n\n'
            'Our clients had always been open source. Now, we have released the source code for our servers.',
      ),
      ChangeLogEntry(
        "Bug Fixes",
        'Many a bugs were squashed in this release.\n'
            '\nIf you run into any, please write to team@ente.io, or let us know on Discord! 🙏',
      ),
    ]);

    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        thickness: 2.0,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ChangeLogEntryWidget(entry: items[index]),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}
