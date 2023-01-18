import 'package:flutter/material.dart';
import 'package:inmans/a1/localization/language_controller.dart';
import 'package:inmans/a1/utils/multilang.dart';
import 'package:inmans/a1/widgets/background.dart';
import 'package:inmans/a1/widgets/cirlce_check_box.dart';
import 'package:inmans/a1/widgets/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String currentLangCode = "tr";
  String currentMoneyUnit = "TRY";

  List<Language> supportedLanguages = [
    Language("tr"),
    Language("en"),
    //Language("fl"),
  ];

  List<String> supportedMoneyUnits = [
    "TRY", /*"USD", "EUR"*/
  ];

  @override
  void initState() {
    super.initState();

    currentLangCode = languageController.getLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: getString("settings"),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  getString("appLanguage"),
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
              ...supportedLanguages.map((language) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        CircleCheckBox(
                          selected: language.langCode == currentLangCode,
                          onSelected: () {
                            setState(() {
                              currentLangCode = language.langCode;
                              languageController
                                  .changeLocale(language.langCode);
                              supportedLanguages = [
                                Language("tr"),
                                Language("en"),
                              ];
                            });
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          language.title,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  getString("moneyUnit"),
                  style: const TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
              ...supportedMoneyUnits.map((money) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        CircleCheckBox(
                          selected: money == currentMoneyUnit,
                          onSelected: () {
                            setState(() {
                              currentMoneyUnit = money;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          money,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }
}

class Language {
  String langCode;
  String title;

  Language(this.langCode) {
    title = getString(langCode);
  }
}
