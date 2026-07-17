/// Mapa simple de nombre de idioma (como está en la tabla `languages`) a
/// un emoji de bandera representativo, para no tener que guardar esa
/// información en la base de datos.
const Map<String, String> _flagsByLanguage = {
  'Español': '🇲🇽',
  'Inglés': '🇺🇸',
  'Francés': '🇫🇷',
  'Alemán': '🇩🇪',
  'Portugués': '🇧🇷',
  'Italiano': '🇮🇹',
  'Japonés': '🇯🇵',
  'Coreano': '🇰🇷',
  'Chino mandarín': '🇨🇳',
};

String flagForLanguage(String languageName) =>
    _flagsByLanguage[languageName] ?? '🌐';