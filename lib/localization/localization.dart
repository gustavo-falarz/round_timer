import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'rounds_label': 'Rounds',
      'round_duration_label': 'Round duration (mm:ss)',
      'rest_duration_label': 'Rest (mm:ss)',
      'delay_duration_label': 'Preparation (ss)',
      'round_warning_label': 'End of round warning (ss)',
      'rest_warning_label': 'End of rest warning (ss)',
      'prepare_label': 'Prepare',
      'rest_label': 'Rest',
      'fight_label': 'Fight',
      'start_label': 'Start',
      'time_label': 'Time',
      'end_label': 'End',
      'round_label': 'Round',
      'timer_title': 'Timer',
      'app_name':'Round Timer'
    },
    'pt': {
      'rounds_label': 'Rounds',
      'round_duration_label': 'Duração do round (mm:ss)',
      'rest_duration_label': 'Descanso (mm:ss)',
      'delay_duration_label': 'Preparação (ss)',
      'round_warning_label': 'Aviso final de round (ss)',
      'rest_warning_label': 'Aviso final de descanso (ss)',
      'prepare_label': 'Prepare-se',
      'rest_label': 'Descanse',
      'fight_label': 'Lute',
      'start_label': 'Começar',
      'time_label': 'Tempo',
      'end_label': 'Fim',
      'round_label': 'Round',
      'timer_title': 'Timer',
      'app_name':'Round Timer'
    },
  };

  String? get roundAmountLabel {
    return _localizedValues[locale.languageCode]!['rounds_label'];
  }
  String? get roundDurationLabel {
    return _localizedValues[locale.languageCode]!['round_duration_label'];
  }
  String? get restDurationLabel {
    return _localizedValues[locale.languageCode]!['rest_duration_label'];
  }
  String? get delayDurationLabel {
    return _localizedValues[locale.languageCode]!['delay_duration_label'];
  }
  String? get roundWarningLabel {
    return _localizedValues[locale.languageCode]!['round_warning_label'];
  }
  String? get restWarningLabel {
    return _localizedValues[locale.languageCode]!['rest_warning_label'];
  }
  String? get prepareLabel {
    return _localizedValues[locale.languageCode]!['prepare_label'];
  }
  String? get restLabel {
    return _localizedValues[locale.languageCode]!['rest_label'];
  }
  String? get fightLabel {
    return _localizedValues[locale.languageCode]!['fight_label'];
  }
  String? get startLabel {
    return _localizedValues[locale.languageCode]!['start_label'];
  }
  String? get timeLabel {
    return _localizedValues[locale.languageCode]!['time_label'];
  }
  String? get endLabel {
    return _localizedValues[locale.languageCode]!['end_label'];
  }
  String? get roundLabel {
    return _localizedValues[locale.languageCode]!['round_label'];
  }
  String? get appName {
    return _localizedValues[locale.languageCode]!['app_name'];
  }
  String? get timerTitle {
    return _localizedValues[locale.languageCode]!['timer_title'];
  }
}
