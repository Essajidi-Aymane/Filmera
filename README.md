
# Filmera

Filmera est une application Flutter permettant de rechercher, découvrir et sauvegarder vos films et séries favoris grâce à l'API The Movie Database (TMDb).

## Description

- **Recherche** de films et séries par titre.
- **Découverte** des tendances du moment.
- **Ajout/Suppression** de favoris.
- **Page de détails** pour chaque film/série.
- **Gestion des favoris** avec une page dédiée.

## Lancer l'application

1. **Prérequis** :
	- Flutter SDK (>=3.9.2)
	- Un compte TMDb pour obtenir une clé API

2. **Cloner le projet** :
	```bash
	git clone <url-du-repo>
	cd filmera
	```

3. **Configurer l'API Key** :
	- Crée un fichier `.env` à la racine du projet (déjà présent normalement)
	- Ajoute ta clé TMDb :
	  ```env
	  TMDB_API_KEY=VOTRE_CLE_API
	  ```

4. **Installer les dépendances** :
	```bash
	flutter pub get
	```

5. **Lancer l'application** :
	```bash
	flutter run
	```

## Librairies utilisées

- [flutter_bloc](https://pub.dev/packages/flutter_bloc) : gestion d'état
- [equatable](https://pub.dev/packages/equatable) : comparaison d'objets
- [http](https://pub.dev/packages/http) : requêtes HTTP
- [cached_network_image](https://pub.dev/packages/cached_network_image) : affichage et cache des images
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) : gestion des variables d'environnement
- [url_launcher](https://pub.dev/packages/url_launcher) : ouverture de liens externes

## API utilisée

- [The Movie Database (TMDb)](https://www.themoviedb.org/documentation/api) : pour récupérer les films, séries, images et détails.

## Auteur
- Projet réalisé par Aymane Essajidi

---


