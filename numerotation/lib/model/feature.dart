import 'package:flutter/material.dart';

import '../RouterGenerator.dart';

///
/// Classe representant une fonctionnalité.
/// Elle est composé d'un nom [name] et d'une page [page]
/// La [page] doit être définie dans le [RouterGenerator]
///
class Feature {
  final String name;
  final String page;

  Feature({this.name, this.page});

  ///
  /// Retourne la liste des fonctionnalités
  ///
  static List<Feature> getList() {
    List<Feature> features = List();
    features.add(Feature(name: "Recherche de contact", page: RouterGenerator.home));
    features.add(Feature(name: "Invitation à télécharger"));
    features.add(Feature(name: "Importation/Exportation contact", page: RouterGenerator.importexport));
    features.add(Feature(name: "Restauration des contacts"));
    features.add(Feature(name: "Connexion d'un utilisateur", page: RouterGenerator.login));
    features.add(Feature(name: "Mise à jour des contacts"));
    return features;
  }


}
