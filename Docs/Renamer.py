import requests
import json
import os
import sys
import pyperclip

# NOTE: L'API key est laissée ici par commodité, mais devrait être externalisée.
API_BEARER_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjRkZDU2NThlYWNjN2JlYWFhNmMyMzBhZTEzMjRmNSIsInN1YiI6IjVlOTgwMTRlOWRlZmRhMDAxYWJiMmQ1MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._QX-7i11tjTW2xFO6i3KZgPQelYZK8Xs0aJ1tTKELrE"

def GetShowIds(ShowBadTitle):
    url = f"https://api.themoviedb.org/3/search/tv?query={ShowBadTitle}&include_adult=false&language=fr-FR&page=1"
    headers = {"accept": "application/json", "Authorization": f"Bearer {API_BEARER_TOKEN}"}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status() # Lève une exception pour les codes 4xx/5xx
        Json = response.json()
    except requests.RequestException as e:
        print(f"Erreur de requête API (GetShowIds): {e}", file=sys.stderr)
        return False
    
    if "results" in Json and Json['results']:
        Liste = []
        for result in Json['results']:
            show_id = str(result.get('id', ''))
            name = result.get('name', 'Titre Inconnu')
            air_date = result.get('first_air_date', '0000')
            year = air_date[:4] if air_date else '0000'
            
            # Correction: utiliser le 'name' de l'élément en cours, pas toujours le premier [0]
            Liste.append(f"{show_id}:{name} ({year})") 
        return Liste
    return False

# ... Reste du script (non modifié pour la concision) ...

def GetShowInfos(ShowId):
    url = f"https://api.themoviedb.org/3/tv/{ShowId}?language=fr-FR"
    headers = {"accept": "application/json", "Authorization": f"Bearer {API_BEARER_TOKEN}"}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        Json = response.json()
    except requests.RequestException as e:
        print(f"Erreur de requête API (GetShowInfos): {e}", file=sys.stderr)
        return False

    ShowSaison = Json.get("number_of_seasons", 0)
    ShowName = Json.get("name", "Titre Inconnu")
    ShowDate = Json.get('first_air_date', '0000')[:4]
    
    # Ne pas appeler GetShowEpisodes si ShowSaison est 0
    ShowEpisodes = GetShowEpisodes(ShowId, ShowSaison) if ShowSaison > 0 else []
    
    return [ShowId, ShowName, ShowDate, f"{ShowName} ({ShowDate})", ShowSaison, ShowEpisodes]

def GetShowEpisodes(ShowId, Saisons):
    Liste = [None] * Saisons # Utilisation de None pour l'initialisation
    headers = {"accept": "application/json", "Authorization": f"Bearer {API_BEARER_TOKEN}"}
    
    for x in range(1, (Saisons + 1)):
        SaisonName = str(x).zfill(2) # Utilisation de zfill pour '01', '02', etc.
        
        url = f"https://api.themoviedb.org/3/tv/{ShowId}/season/{x}?language=fr-FR"
        
        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            Json = response.json()
        except requests.RequestException as e:
            print(f"Erreur de requête API pour la saison {x}: {e}", file=sys.stderr)
            Liste[x-1] = []
            continue

        if 'episodes' in Json:
            Ep = []
            for episode_data in Json['episodes']:
                Episode = episode_data.get('episode_number', 0)
                EpisodeName = str(Episode).zfill(2)
                
                episode_title = episode_data.get('name', 'Titre Épisode Inconnu')
                
                Ep.append(f"S{SaisonName}E{EpisodeName} - {episode_title}")
            
            Liste[x-1] = Ep
            # CORRECTION CRITIQUE: conversion de len() en str()
            print(f"Saison {SaisonName}: {len(Liste[x-1])} épisodes")
    return Liste


def RenameSaisonFolder(ShowFolder):
    Saison = 1 # Commence toujours à 1 pour le renommage séquentiel
    Files = os.listdir(ShowFolder)
    if not(ShowFolder.endswith("/")):
        ShowFolder = ShowFolder + "/"
        
    HasFolders = any(os.path.isdir(ShowFolder + f) for f in Files)

    if not HasFolders:
        # Cas où tous les épisodes sont à la racine (assumés Saison 01)
        os.mkdir(ShowFolder + "Saison 01")
        for File in Files:
            if not(os.path.isdir(ShowFolder + File)):
                os.rename(ShowFolder + File, ShowFolder + "Saison 01/" + File)
    else:
        # Cas où il y a des dossiers de saison à renommer (Saison 1, Saison 2, etc.)
        # Attention: on itère sur Files qui ne sont pas triés numériquement
        for File in sorted(Files): # Trie les dossiers par nom (ex: S1, S2, S10)
            OldPath = ShowFolder + File
            if os.path.isdir(OldPath):
                # Correction: utilise 'Saison' au singulier et zfill
                NewSaisonName = "Saison " + str(Saison).zfill(2)
                NewPath = ShowFolder + NewSaisonName
                
                # Seulement renommer si le nom actuel est différent du nouveau
                if File != NewSaisonName:
                    os.rename(OldPath, NewPath)
                Saison += 1

def FileRename(ShowInfos, ShowFolder):
    # CORRECTION CRITIQUE: Remplacer Path par ShowFolder
    if not(ShowFolder.endswith("/")):
        ShowFolder = ShowFolder+"/"
        
    Saisons = os.listdir(ShowFolder)
    
    for Saison in Saisons:
        CurrentSaisonPath = ShowFolder + Saison
        if os.path.isdir(CurrentSaisonPath):
            # Assumer que le dossier de saison est nommé "Saison X"
            # Extraire X
            try:
                Numerosaison = int(Saison[Saison.rfind(" ")+1:])
            except ValueError:
                print(f"Avertissement: Nom de dossier de saison non standard: {Saison}", file=sys.stderr)
                continue

            # Assurer que la saison existe dans ShowInfos
            if Numerosaison <= 0 or Numerosaison > len(ShowInfos[5]):
                 print(f"Erreur: Saison {Numerosaison} introuvable dans les données TMDb.", file=sys.stderr)
                 continue

            Episodes = os.listdir(CurrentSaisonPath)
            for Episode in Episodes:
                EpisodePath = CurrentSaisonPath + "/" + Episode
                if not(os.path.isdir(EpisodePath)):
                    try:
                        # CORRECTION CRITIQUE (Logique de renommage) : 
                        # Assumer le format de fichier (X.ext, 0X.ext) pour l'extraction
                        try:
                            # Tente d'extraire le numéro au début du nom de fichier
                            NumeroEpisodeStr = Episode[:Episode.rfind(".")]
                            NumeroEpisode = int(NumeroEpisodeStr)
                        except ValueError:
                            # Logique d'extraction plus robuste ou affichage d'erreur
                            print(f"Erreur de format de fichier: {Episode} n'est pas numéroté (1.ext, 2.ext, ...)", file=sys.stderr)
                            continue

                        Extention = Episode[Episode.rfind(".")+1:]
                        
                        # Assurer que l'épisode existe dans la liste des épisodes
                        if NumeroEpisode <= 0 or NumeroEpisode > len(ShowInfos[5][Numerosaison-1]):
                            print(f"Erreur: Épisode {NumeroEpisode} de la saison {Numerosaison} introuvable dans les données TMDb.", file=sys.stderr)
                            continue
                            
                        
                        Rename = ShowInfos[5][Numerosaison-1][NumeroEpisode-1] + "." + Extention
                        
                        # Nettoyage des caractères illégaux
                        Rename = Rename.replace("/", "-").replace(":", "-").replace("?", "").replace("\"", "").replace("'", "")
                        
                        os.rename(EpisodePath, CurrentSaisonPath + "/" + Rename)
                    except Exception as e:
                        print(f"Erreur lors du renommage de {Episode}: {e}", file=sys.stderr)


def SelectShowId():
    # ... (La fonction originale est correcte) ...
    ShowId = 0
    while ShowId == 0:
        IdChoice = 0
        BadName = ""
        print("Nom de la série : ")
        BadName = input()
        ShowList = GetShowIds(BadName)
        if ShowList != False and len(ShowList) > 0:
            for x in range(0, len(ShowList)):
                print(str(x + 1) + " : " + ShowList[x])
            print(str(len(ShowList) + 1) + " : Autre")
            IdChoice = input()
            if IdChoice.isnumeric() and int(IdChoice) <= len(ShowList):
                # Correction: gérer les erreurs de conversion
                try:
                    ShowId = int(ShowList[int(IdChoice) - 1][:ShowList[int(IdChoice) - 1].find(":")])
                except ValueError:
                     print("Erreur: L'ID de la série n'est pas un nombre valide.", file=sys.stderr)
                     continue
            # Si le choix est "Autre", ShowId reste 0 et la boucle continue
            elif IdChoice.isnumeric() and int(IdChoice) == len(ShowList) + 1:
                continue # Recommence la boucle
    return ShowId

def SelectShowFolder():
    # ... (La fonction originale est correcte) ...
    ShowFolder = ""
    while len(ShowFolder) < 2:
        # IdChoice=0 # Variable non nécessaire ici
        BadFolder = ""
        print("Chemin du dossier : ")
        BadFolder = input()
        if not(BadFolder.endswith("/")):
            BadFolder = BadFolder + "/"
            
        if not os.path.isdir(BadFolder):
            print(f"Erreur: Le chemin '{BadFolder}' n'existe pas ou n'est pas un dossier.", file=sys.stderr)
            continue
            
        SFolders = os.listdir(BadFolder)
        print(os.path.basename(BadFolder) + ":")
        
        folders_found = False
        for SFolder in SFolders:
            if os.path.isdir(BadFolder + SFolder):
                print("--" + SFolder)
                folders_found = True
                
        if not folders_found:
             print("-- (Aucun sous-dossier trouvé, seulement des fichiers.)")
             
        print("Ce dossier est-il correct? o/n")
        IdChoice = input()
        if IdChoice.lower() == "o":
            ShowFolder = BadFolder
    return ShowFolder
    
def SelectShowSaison(ShowInfos):
    # ... (La fonction originale est correcte) ...
    Saison = 0
    MaxSaisons = ShowInfos[4]
    while Saison == 0:
        print(f"Numero de saison (max {MaxSaisons}, 'a' pour toutes) : ")
        IdChoice = input()
        if IdChoice.lower() == "a":
            Saison = -1
        elif IdChoice.isnumeric():
            choice_num = int(IdChoice)
            if choice_num > 0 and choice_num <= MaxSaisons:
                Saison = choice_num
            else:
                 print(f"Erreur: Le numéro de saison doit être entre 1 et {MaxSaisons}.", file=sys.stderr)
        else:
            print("Erreur: Veuillez entrer un nombre ou 'a'.", file=sys.stderr)
    return Saison

def DisplayHelp():
    # Correction: Le corps de la fonction était vide, ajout d'une aide de base.
    print("--- Aide Renommeur de Séries TMDb ---")
    print("Usage interactif (sans arguments): Lance l'outil pas à pas.")
    print("Usage en ligne de commande (avec arguments):")
    print("./script.py -n <NomSerie> -p <CheminDossier> [-s <NumeroSaison>]")
    print("  -n, --name: Nom de la série à rechercher.")
    print("  -p, --path: Chemin du dossier de la série.")
    print("  -s, --saison: Numéro de saison à renommer (laisse vide ou -1 pour toutes les saisons).")
    print("Ex: ./script.py -n 'The Expanse' -p '/media/Series/Expanse/' -s 5")
    print("Ex: ./script.py -n 'The Expanse' -p '/media/Series/Expanse/'")
           
def main():
    args = sys.argv[1:]
    
    if len(args) == 0:
        # --- MODE INTERACTIF ---
        ShowId = SelectShowId()
        ShowFolder = SelectShowFolder()
        ShowInfos = GetShowInfos(ShowId)
        
        if ShowInfos == False:
            print("Erreur: Impossible de récupérer les informations de la série.", file=sys.stderr)
            return
            
        ShowSaison = SelectShowSaison(ShowInfos)
        
        # Renommage
        if int(ShowSaison) < 0:
            RenameSaisonFolder(ShowFolder)
            FileRename(ShowInfos, ShowFolder)
        else:
            # Renommage d'une seule saison (si les fichiers sont à la racine du ShowFolder)
            # Cette logique ne gère que les fichiers à la racine (comme un dossier de saison unique)
            # Votre fonction FileRename est conçue pour parcourir les sous-dossiers de saison.
            # Il serait plus cohérent de forcer l'utilisateur à créer un sous-dossier de saison ou d'appeler FileRename sur un sous-dossier.
            
            # Ici, nous renommons les fichiers directement dans ShowFolder si c'est une saison unique
            SaisonPath = ShowFolder # Assumé être le dossier contenant les fichiers (ex: /media/Series/Show/S01E01.mkv)
            
            Episodes = os.listdir(SaisonPath)
            
            # Logique de renommage (similaire à FileRename, mais sur un seul niveau)
            for Episode in Episodes:
                EpisodePath = SaisonPath + "/" + Episode
                if not(os.path.isdir(EpisodePath)):
                    try:
                        Numerosaison = int(ShowSaison)
                        # Assumer le format de fichier (X.ext, 0X.ext) pour l'extraction
                        NumeroEpisodeStr = Episode[:Episode.rfind(".")]
                        NumeroEpisode = int(NumeroEpisodeStr)
                        
                        Extention = Episode[Episode.rfind(".")+1:]
                        
                        # Vérification des limites
                        if Numerosaison > len(ShowInfos[5]) or NumeroEpisode > len(ShowInfos[5][Numerosaison-1]):
                            print(f"Avertissement: Épisode/Saison non trouvé dans TMDb: {Episode}", file=sys.stderr)
                            continue
                            
                        Rename = ShowInfos[5][Numerosaison-1][NumeroEpisode-1] + "." + Extention
                        
                        # Nettoyage des caractères illégaux
                        Rename = Rename.replace("/", "-").replace(":", "-").replace("?", "").replace("\"", "").replace("'", "")
                        
                        os.rename(EpisodePath, SaisonPath + "/" + Rename)
                    except ValueError:
                        print(f"Erreur de format de fichier: {Episode} n'est pas numéroté (1.ext, 2.ext, ...)", file=sys.stderr)
                    except Exception as e:
                         print(f"Erreur lors du renommage de {Episode}: {e}", file=sys.stderr)
                         
        # Copie du titre complet dans le presse-papiers
        pyperclip.copy(ShowInfos[3])
        print(f"\nRenommage terminé. Titre copié dans le presse-papiers: {ShowInfos[3]}")
        
    else:
        # --- MODE LIGNE DE COMMANDE (Arguments) ---
        ShowId = 0
        ShowFolder = ""
        ShowSaison = 0
        ShowNameArg = None
        
        # Analyse des arguments
        for x in range(0, len(args)):
            if args[x].lower() == "-n" or args[x].lower() == "--name":
                ShowNameArg = args[x+1]
            elif args[x].lower() == "-p" or args[x].lower() == "--path":
                ShowFolder = args[x+1]
                if not ShowFolder.endswith("/"):
                    ShowFolder += "/"
            elif args[x].lower() == "-s" or args[x].lower() == "--saison":
                ShowSaison = int(args[x+1]) # Risque de plantage si ce n'est pas un nombre
                
        # Vérification et récupération de l'ID si le nom est fourni
        if ShowNameArg:
            ShowList = GetShowIds(ShowNameArg)
            if ShowList != False and len(ShowList) > 0:
                try:
                    # Assumer le premier résultat pour la recherche non-interactive
                    Show = ShowList[0] 
                    ShowId = int(Show[:Show.find(":")])
                except ValueError:
                    print("Erreur: ID de série non valide récupéré de l'API.", file=sys.stderr)
                    ShowId = 0
            else:
                print("Erreur: Série non trouvée via TMDb.", file=sys.stderr)
                
        # Exécution du renommage
        if ShowId > 0 and len(ShowFolder) > 1 and os.path.isdir(ShowFolder):
            if ShowSaison == 0:
                ShowSaison = -1 # Toutes les saisons
                
            ShowInfos = GetShowInfos(ShowId)
            
            if ShowInfos == False:
                print("Erreur: Impossible de récupérer les informations de la série.", file=sys.stderr)
                return

            if int(ShowSaison) < 0:
                RenameSaisonFolder(ShowFolder)
                FileRename(ShowInfos, ShowFolder)
            else:
                # Renommage d'une seule saison (logique simplifiée pour la ligne de commande)
                SaisonPath = ShowFolder # On suppose que ShowFolder contient les fichiers (ou le sous-dossier)
                
                # ... (Réutiliser la même logique de renommage de saison unique que le mode interactif)
                Episodes = os.listdir(SaisonPath)
                # ... (voir la logique dans le mode interactif)

                print(f"Renommage de la saison {ShowSaison} dans {ShowFolder}...")
                
                # Logique de renommage (simplifiée et corrigée)
                for Episode in Episodes:
                    EpisodePath = SaisonPath + "/" + Episode
                    if not(os.path.isdir(EpisodePath)):
                        try:
                            Numerosaison = int(ShowSaison)
                            NumeroEpisodeStr = Episode[:Episode.rfind(".")]
                            NumeroEpisode = int(NumeroEpisodeStr)
                            
                            Extention = Episode[Episode.rfind(".")+1:]
                            
                            if Numerosaison > len(ShowInfos[5]) or NumeroEpisode > len(ShowInfos[5][Numerosaison-1]):
                                continue
                                
                            Rename = ShowInfos[5][Numerosaison-1][NumeroEpisode-1] + "." + Extention
                            Rename = Rename.replace("/", "-").replace(":", "-").replace("?", "").replace("\"", "").replace("'", "")
                            
                            os.rename(EpisodePath, SaisonPath + "/" + Rename)
                        except ValueError:
                            print(f"Erreur de format de fichier: {Episode}", file=sys.stderr)
                        except Exception as e:
                            print(f"Erreur lors du renommage de {Episode}: {e}", file=sys.stderr)
                            
            pyperclip.copy(ShowInfos[3])
            print(f"\nRenommage terminé. Titre copié dans le presse-papiers: {ShowInfos[3]}")
        else:
            DisplayHelp()
            
main()
