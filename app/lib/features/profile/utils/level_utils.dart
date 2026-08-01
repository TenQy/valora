class LevelUtils {
  static const _defaultLevels = [
    'Estudiante',
    'Practicante',
    'Junior',
    'Semi Senior',
    'Senior',
    'Especialista'
  ];

  static final Map<String, List<String>> _levelsByAreaName = {
    'Tecnología': [
      'Estudiante',
      'Practicante',
      'Junior',
      'Semi Senior',
      'Senior',
      'Lead / Staff'
    ],
    'Diseño': [
      'Estudiante',
      'Practicante',
      'Junior',
      'Semi Senior',
      'Senior',
      'Lead / Director'
    ],
    'Marketing': [
      'Estudiante',
      'Becario',
      'Junior',
      'Analista / Semi Senior',
      'Senior',
      'Director'
    ],
    'Administración': [
      'Estudiante',
      'Auxiliar',
      'Analista',
      'Coordinador',
      'Gerente',
      'Director'
    ],
    'Finanzas': [
      'Estudiante',
      'Becario',
      'Analista',
      'Consultor',
      'Gerente',
      'Socio / Director'
    ],
    'Arquitectura': [
      'Estudiante',
      'Dibujante',
      'Arquitecto Junior',
      'Proyectista',
      'Arquitecto Senior',
      'Director'
    ],
    'Ingenierías': [
      'Estudiante',
      'Practicante',
      'Ingeniero Junior',
      'Ingeniero de Proyecto',
      'Ingeniero Senior',
      'Especialista'
    ],
    'Salud': [
      'Estudiante',
      'Interno',
      'Pasante',
      'Médico General',
      'Residente',
      'Especialista',
      'Adscrito'
    ],
    'Educación': [
      'Estudiante',
      'Auxiliar',
      'Docente Titular',
      'Coordinador',
      'Director',
      'Investigador'
    ],
    'Derecho': [
      'Estudiante',
      'Pasante',
      'Abogado Junior',
      'Asociado',
      'Asociado Senior',
      'Socio'
    ],
  };

  static List<String> getLevelsForArea(String? areaName) {
    if (areaName == null) return _defaultLevels;
    return _levelsByAreaName[areaName] ?? _defaultLevels;
  }

  static int getMaxYearsForLevel(String level) {
    switch (level) {
      case 'Estudiante':
        return 2;
      case 'Practicante':
      case 'Becario':
      case 'Interno':
      case 'Dibujante':
      case 'Auxiliar':
      case 'Pasante':
        return 3;
      case 'Junior':
      case 'Ingeniero Junior':
      case 'Abogado Junior':
      case 'Arquitecto Junior':
        return 5;
      case 'Semi Senior':
      case 'Analista':
      case 'Analista / Semi Senior':
      case 'Docente Titular':
      case 'Médico General':
      case 'Residente':
      case 'Proyectista':
      case 'Ingeniero de Proyecto':
      case 'Asociado':
        return 10;
      default:
        return 70; // Senior, Especialista, Director, etc.
    }
  }
}
