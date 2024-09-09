import 'package:flutter/material.dart';

enum AppLanguage { en, pt, es }

class Translation {
  static AppLanguage _currentLanguage = AppLanguage.es;

  static final Map<AppLanguage, Map<String, String>> _localizedValues = {
    AppLanguage.en: {
      'Nome': 'Name',
      'Idade': 'Age',
      'Descrição': 'Description',
      'Editar Pessoa:': 'Edit Person',
      'Medida Superior': 'Upper Measurement',
      'Medida Inferior': 'Lower Measurement',
      'Nenhuma pessoa encontrada.': 'No person found.',
      'Inserir Pessoa': 'Insert Person',
      'Cancelar': 'Cancel',
      'Excluir': 'Delete',
      'Confirmar Exclusão': 'Confirm Deletion',
      'Você tem certeza que deseja excluir esta pessoa?': 'Are you sure you want to delete this person?',
    },
    AppLanguage.pt: {
      'Nome': 'Nome',
      'Idade': 'Idade',
      'Descrição': 'Descrição',
      'Editar Pessoa:': 'Editar Pessoa:',
      'Medida Superior': 'Medida Superior',
      'Medida Inferior': 'Medida Inferior',
      'Nenhuma pessoa encontrada.': 'Nenhuma pessoa encontrada.',
      'Inserir Pessoa': 'Inserir Pessoa',
      'Cancelar': 'Cancelar',
      'Excluir': 'Excluir',
      'Confirmar Exclusão': 'Confirmar Exclusão',
      'Você tem certeza que deseja excluir esta pessoa?': 'Você tem certeza que deseja excluir esta pessoa?',
    },
    AppLanguage.es: {
      'Nome': 'Nombre',
      'Idade': 'Edad',
      'Descrição': 'Descripción',
      'Editar Pessoa:': 'Editar persona',
      'Medida Superior': 'Medida Superior',
      'Medida Inferior': 'Medida Inferior',
      'Nenhuma pessoa encontrada.': 'No se encontró ninguna persona.',
      'Inserir Pessoa': 'Insertar Persona',
      'Cancelar': 'Cancelar',
      'Excluir': 'Eliminar',
      'Confirmar Exclusão': 'Confirmar Eliminación',
      'Você tem certeza que deseja excluir esta pessoa?': '¿Está seguro de que desea eliminar a esta persona?',
    },
  };

  static void setLanguage(AppLanguage language) {
    _currentLanguage = language;
  }

  static String translate(String key) {
    return _localizedValues[_currentLanguage]?[key] ?? key;
  }
}
