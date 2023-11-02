# SCRIPT D'EXTRACTION DES DONNÉES DE PRTG

Ce script PowerShell est conçu pour extraire des données des appareils et des capteurs du serveur PRTG et les exporter dans un fichier CSV.

## Description

Le script utilise l'API PRTG pour récupérer des informations sur tous les appareils et capteurs enregistrés dans votre serveur PRTG. Les données extraites sont ensuite exportées dans un fichier CSV pour un examen et une analyse plus faciles. Les données récupérées dans le script sont les suivantes :
- **ID Appareil:**
- **Appareil:**
- **Groupe:**
- **Hôte:**
- **ID Capteur:**
- **Capteur:**



## Date de Création

Ce script a été créé le 10 octobre 2023.

## Prérequis

- PowerShell doit être installé sur votre machine.
- Vous devez avoir accès à un serveur PRTG avec les droits nécessaires pour extraire les données.

## Paramètres

Voici la liste des paramètres que vous pouvez configurer lorsque vous exécutez le script :

- **PRTGServer** : L'URL de votre serveur PRTG.
- **UserName** : Votre nom d'utilisateur pour accéder au serveur PRTG.
- **Passhash** : Le hash de votre mot de passe pour accéder au serveur PRTG.
- **OutputFile** : Le chemin où le fichier CSV contenant les données extraites sera enregistré. Par défaut, il est réglé sur "$HOME\PRTG-Export.csv".

## Utilisation

1. Ouvrez PowerShell.
2. Naviguez vers le répertoire contenant le script.
3. Exécutez le script avec les paramètres appropriés, par exemple :

```powershell
.\prtb.ps1 -PRTGServer "https://prtg.ga.fr" -UserName "VotreNomUtilisateur" -Passhash "LePasshash"
```

Remplacez `.\prtb.ps1` par le nom réel de votre fichier script et les autres paramètres en fonction de votre configuration.

Le script affichera le progrès dans la console et enregistrera les données extraites dans le fichier CSV spécifié.

## Erreurs et Dépannage

Si une erreur se produit pendant l'exécution du script, un message d'erreur sera affiché dans la console PowerShell avec des détails sur l'erreur. Assurez-vous que vos paramètres sont corrects et que le serveur PRTG est accessible.

### Exemples d’Erreurs Communes

- **Erreur de Connexion :** Assurez-vous que l'URL du serveur PRTG, le nom d'utilisateur et le passhash sont corrects et que le serveur est accessible depuis votre machine.

- **Erreur d'Écriture du Fichier :** Assurez-vous que le chemin spécifié pour le fichier de sortie est accessible en écriture et n'est pas utilisé par un autre processus.

## Licence

Ce script est partagé tel quel, et vous êtes libre de l'utiliser et de le modifier selon vos besoins. Assurez-vous de tester le script dans un environnement de test avant de l'utiliser dans un environnement de production.

## Auteur

Gregory
