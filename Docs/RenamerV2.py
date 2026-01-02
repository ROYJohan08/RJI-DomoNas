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
            Liste.append(f"{show_id}:{name} ({year})")
        return Liste

def getNameInfo(name):
    annee = getAnnee(name)
    titre = getTitre(name)
    ext = getExtention(name)
    return titre, annee, ext

folder = main()
print(f"Le chemin reçu est : {folder.absolute()}")
Files = listFiles(folder)
Dossier = listFolder(folder)
nomcrad="Inception.2010.MULTI.1080p.BluRay.x264-REPACK.mkv"
print(f"{clearName(nomcrad)}")
nom = clearName(nomcrad)
Name, year, ext = getNameInfo(nom)
print(Name + " (" + year + ")" + ext)
token = getCredentialValue()
print(token)
Result = searchTvShow("Malcolm")
print(Result)
