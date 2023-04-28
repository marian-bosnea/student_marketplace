import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_marketplace_presentation/core/theme/theme_bloc.dart';

class SettingsViewPage extends StatefulWidget {
  const SettingsViewPage({super.key});

  @override
  State<SettingsViewPage> createState() => _SettingsViewPageState();
}

class _SettingsViewPageState extends State<SettingsViewPage> {
  late bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PlatformAppBar(
        backgroundColor: Theme.of(context).highlightColor,
        cupertino: (context, platform) =>
            CupertinoNavigationBarData(previousPageTitle: 'Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Appearance',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Theme Mode',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Material(
                        elevation: 0,
                        type: MaterialType.transparency,
                        child: AnimatedToggleSwitch<bool>.dual(
                          current: isDarkMode,
                          first: false,
                          second: true,
                          dif: 20.0,
                          borderColor: Colors.transparent,
                          borderWidth: 5.0,
                          height: 50,
                          innerColor: Theme.of(context).highlightColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1.5),
                            ),
                          ],
                          onChanged: (b) {
                            if (b) {
                              BlocProvider.of<ThemeBloc>(context)
                                  .setTheme(ThemeMode.dark);
                            } else {
                              BlocProvider.of<ThemeBloc>(context)
                                  .setTheme(ThemeMode.light);
                            }

                            setState(() => isDarkMode = b);
                          },
                          colorBuilder: (b) => b
                              ? Colors.indigo.shade600
                              : Colors.orange.shade600,
                          iconBuilder: (value) => value
                              ? const Icon(FontAwesomeIcons.moon)
                              : const Icon(FontAwesomeIcons.lightbulb),
                          textBuilder: (value) => value
                              ? Center(
                                  child: Text(
                                  'Dark',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ))
                              : Center(
                                  child: Text(
                                  'Light',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )),
                        ),
                      ),
                      //     BlocProvider.of<ThemeBloc>(context).setTheme(theme);
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
