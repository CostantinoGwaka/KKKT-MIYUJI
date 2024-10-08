// enum AppLanguage { English, Swahili, French, Spanish, Portugese }
enum AppLanguage { English, Swahili }


/// Returns enum value name without enum class name.
String enumName(AppLanguage anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appLanguageData = {
  AppLanguage.English: {"value": "en", "name": "English"},
  AppLanguage.Swahili: {"value": "sw", "name": "Swahili"},
  // AppLanguage.French: {"value": "fr", "name": "French"},
  // AppLanguage.Spanish: {"value": "es", "name": "Spanish"},
  // AppLanguage.Portugese: {"value": "pt", "name": "Portugese"},
};
