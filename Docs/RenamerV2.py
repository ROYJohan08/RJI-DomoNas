import requests
import json
import sys
from pathlib import Path
import glob
import re
import os

def main():
    folder=""
    if len(sys.argv) > 1:
        chemin_brut = sys.argv[1]
        folder = Path(chemin_brut)
        if not folder.exists():
            folder = Path("./")
    else:
        folder = Path("./")
    return folder

def listFiles(folder):
    extensions_video = {".mkv", ".mp4", ".avi", ".mov", ".wmv"}
    medias_video = [f for f in folder.iterdir() if f.suffix.lower() in extensions_video]
    return medias_video
def listFolder(folder):
    dossiers = [f for f in folder.iterdir() if f.is_dir()]
    return dossiers
def clearName(name):
    name = re.sub(r'[\._\-]', ' ', name)
    mots_cles = r'(?i)\b(720p|1080p|2160p|4k|x264|x265|hevc|multi|french|truefrench|vff|vostfr|ac3|dts|bluray|webrip|hdtv|repack|crf24|xvid|aac)\b'
    name = re.sub(mots_cles, '', name)
    name = re.sub(r'-\w+$|\[.*?\]', '', name)
    name = ".".join(name.split())
    name = name.title()
    return name
def getAnnee(name):
    match = re.search(r'\b(19|20)\d{2}\b', name)
    if match:
        return match.group(0)
    return None
def getTitre(name):
    parties = re.split(r'\b(?:19|20)\d{2}\b', name)
    titre = parties[0].replace('.', ' ').strip()
    return titre
def getExtention(name):
    nom, extention = os.path.splitext(name)
    return extention.lower()
def getCredentialValue():
    file_path="/media/Runable/Docker/credentials.sh"
    try:
        with open(file_path, 'r') as file:
            for line in file:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                if line.startswith(f"TMDBApiToken="):
                    _, value = line.split('=', 1)
                    return value.strip().strip('"').strip("'").strip()
    except FileNotFoundError:
        return "Erreur : Fichier introuvable."
    except Exception as e:
        return f"Erreur : {e}"
    return None
def callApi(url):
    API_BEARER_TOKEN=getCredentialValue()
    if not API_BEARER_TOKEN or len(API_BEARER_TOKEN)<200:
        return "Erreur"
    headers = {"accept": "application/json", "Authorization": f"Bearer {API_BEARER_TOKEN}"}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        JsonResult = response.json()
        return JsonResult
    except requests.RequestException as e:
        print(f"Erreur de requête API (callApi): {e}", file=sys.stderr)
        return False
def searchTvShow(name):
    url = f"https://api.themoviedb.org/3/search/tv?query={name}&include_adult=false&language=fr-FR&page=1"
    Results = callApi(url)
    if "results" in Results and Results['results']:
        Liste = []
        for result in Results['results']:
            show_id = str(result.get('id', ''))
            name = result.get('name', 'Titre Inconnu')
            air_date = result.get('first_air_date', '0000')
            year = air_date[:4] if air_date else '0000'
            Liste.append([show_id, name, year])
        return Liste
def searchMovie(name):
    url = f"https://api.themoviedb.org/3/search/movie?query={name}&include_adult=false&language=fr-FR&page=1"
    Results = callApi(url)
    if "results" in Results and Results['results']:
        Liste = []
        for result in Results['results']:
            movie_id = str(result.get('id', ''))
            title = result.get('title', 'Titre Inconnu')
            release_date = result.get('release_date', '0000')
            year = release_date[:4] if release_date else '0000'
            Liste.append([movie_id, title, year])
        return Liste
    return []
def validTvShow(List, year):
    List2 = []
    for result in List:
        if result[2] == year:
            List2.append(result)
    if(len(List2)==1):
        return List2
    return List;
def getNameInfo(name):
    annee = getAnnee(name)
    titre = getTitre(name)
    ext = getExtention(name)
    return titre, annee, ext
def getShowInfos(ShowId):
    url = f"https://api.themoviedb.org/3/tv/{ShowId}?language=fr-FR"
    Result = callApi(url)
    ShowSaison = Result.get("number_of_seasons", 0)
    ShowName = Result.get("name", "Titre Inconnu")
    ShowDate = Result.get('first_air_date', '0000')[:4]
    ShowEpisodes = GetShowEpisodes(ShowId, ShowSaison) if ShowSaison > 0 else []
    return [ShowId, ShowName, ShowDate, f"{ShowName} ({ShowDate})", ShowSaison, ShowEpisodes]
def GetShowEpisodes(ShowId, Saisons):
    Liste = [None] * Saisons
    for x in range(1, (Saisons + 1)):
        SaisonName = str(x).zfill(2)
        url = f"https://api.themoviedb.org/3/tv/{ShowId}/season/{x}?language=fr-FR"
        Result = callApi(url)
        if 'episodes' in Result:
            Ep = []
            for episode_data in Result['episodes']:
                Episode = episode_data.get('episode_number', 0)
                EpisodeName = str(Episode).zfill(2)
                episode_title = episode_data.get('name', 'Titre Épisode Inconnu')
                Ep.append(f"S{SaisonName}E{EpisodeName} - {episode_title}")
            Liste[x-1] = Ep
            print(f"Saison {SaisonName}: {len(Liste[x-1])} épisodes")
    return Liste

def tests():
    print("##Test chemin : ")
    folder = main()
    print(f"-> Le chemin reçu est : {folder.absolute()}")
    
    print("##Test lecture fichiers : ")
    Files = listFiles(folder)
    for x in Files:
        print(f"-> Fichier trouvé : {x.name}")
    print("##Test lecture dossiers : ")
    Dossier = listFolder(folder)
    for x in Dossier:
        print(f"-> Dossier trouvé : {x.name}")
    print("##Test nettoyage nom : ")
    nomcrad="Inception.2010.MULTI.1080p.BluRay.x264-REPACK.mkv"
    print(f"-> {nomcrad} deviens : {clearName(nomcrad)}")
    nom = clearName(nomcrad)
    print("##Test extraction infos : ")
    Name, year, ext = getNameInfo(nom)
    print(f"-> Nom : {Name} | annee : {year} | ext : {ext}")
    print("##Test récupération token : ")
    token = getCredentialValue()
    print(f"-> Token : {token}")
    print("##Test recherche série : ")
    Result = searchTvShow("Malcolm")
    print(f"-> Résultat de la recherche : {Result}")
    year="2000"
    print("##Test nettoyage résultats : ")
    Liste2 = validTvShow(Result,year)
    print(f"-> Résultat de la recherche : {Liste2}")
    print("##Test recherche film : ")
    Result = searchMovie("Inception")
    print(f"-> Résultat de la recherche : {Result}")
    year="2010"
    print("##Test nettoyage résultats : ")
    Liste2 = validTvShow(Result,year)
    print(f"-> Résultat de la recherche : {Liste2}")
    print("##Test lecture informations : ")
    Infos = getShowInfos("2004")
    print(Infos)


tests()
