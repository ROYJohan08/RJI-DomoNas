import requests
import json
import sys
from pathlib import Path
import glob
import re
import os

def main():
    defaultFolder = getDefaultFolder() # Getting the default folder from args
    videoFiles = listAllFiles(defaultFolder) # List all files for the default folder
    for videoFile in videoFiles:
        videoName, videoYear, videoExt, videoSaison, videoEpisode = getInfoFromFile(videoFile)
        if isTvShow(videoFile.name):
            Info = searchTvShow(videoName,videoYear)
            showId, showName, showDate, showEpisodes = getTvShowInfo(Info[0])
            print(f"'{showName} ({showDate})'/'Saison {videoSaison.zfill(2)}'/'{showEpisodes[int(videoSaison)-1][int(videoEpisode)-1]}{videoExt}'")
            moveTvShow(defaultFolder, videoFile, showName, showDate, videoSaison, showEpisodes,videoEpisode,videoExt)
        else:
            Info = searchMovie(videoName, videoYear)
            print(f"'{Info[1]} ({Info[2]}){videoExt}'")

def moveTvShow(defaultFolder,videoFile, showName, showDate, videoSaison, showEpisodes, videoEpisode, videoExt):
    defaultFolder = str(Path(defaultFolder))
    folder = Path(defaultFolder + "/" + showName + " (" + showDate + ")")
    if not folder.exists():
        os.mkdir(folder)
    folder = Path(str(folder) + "/Saison " + videoSaison.zfill(2))
    if not folder.exists():
        os.mkdir(folder)
    newFile = Path(str(folder) + "/" + showEpisodes[int(videoSaison)-1][int(videoEpisode)-1] + videoExt)
    if not newFile.exists() and videoFile.exists():
        os.rename(videoFile, newFile)

def searchMovie(videoName, videoYear):
    url = f"https://api.themoviedb.org/3/search/movie?query={videoName}&include_adult=false&language=fr-FR&page=1" # Get url for search movies
    results = callApi(url) # Call api with this URL
    if "results" in results and results['results']: # If result is not empty and result contain data
        Liste = [] # Creating list
        for result in results['results']: # For each results
            movieId = str(result.get('id', '')) # Get id form result
            movieName = result.get('title', 'Titre Inconnu') # Get name from result
            temp = result.get('release_date', '0000') # Get first air date
            movieYear = temp[:4] if temp else '0000' # Change fad to year
            Liste.append([movieId, movieName, movieYear]) # Add to Liste
        List2 = []
        for result in Liste[:6]:
            if result[2] == videoYear:
                List2.append(result)
        if len(List2)==1:
            return List2[0]
        elif len(Liste)==0:
            print("Aucun résultat n'a été trouvé pour '{videoName} ({videoYear})'.")
            print("Merci de saisir le nom manuellement : ")
            videoName = input()
            return searchMovie(videoName,videoYear)
        elif len(Liste)>1:
            print(f"Plusieurs résultats ont été trouvés pour '{videoName} ({videoYear})' : ")
            print("Saisissez l'option corespondant à votre recherche")
            print("0 : Quitter.")
            print("1 : Saisir le nom manuellement.")
            for i in range(len(Liste)):
                print(f"{i+2} : {Liste[i][1]} ({Liste[i][2]}).")
            Select = input()
            if Select==0:
                return None
            elif Select>1 and Select<len(Liste)+2:
                return Liste[Select-2]
            else:
                print("Vous avez séléctionné la saisie manuelle du nom.")
                print("Merci de saisir le nom manuellement :")
                videoName = input()
                return searchMovie(videoName, videoYear)
    else:
        print(f"Aucun résultat n'a été trouvé pour '{videoName} ({videoYear})'.")
        print("Merci de saisir le nom manuellement : ")
        videoName = input()
        return searchMovie(videoName, videoYear)

def getTvShowInfo(ShowId):
    url = f"https://api.themoviedb.org/3/tv/{ShowId}?language=fr-FR"
    result = callApi(url)
    showSaison = result.get("number_of_seasons", 0)
    showName = result.get("name", "Titre Inconnu")
    showDate = result.get('first_air_date', '0000')[:4]
    showEpisodes = [None] * showSaison
    for x in range(1, (showSaison + 1)):
        saisonName = str(x).zfill(2)
        url = f"https://api.themoviedb.org/3/tv/{ShowId}/season/{x}?language=fr-FR"
        result = callApi(url)
        if 'episodes' in result:
            saisonEpisodes = []
            for episodeData in result['episodes']:
                episodeNumber = episodeData.get('episode_number', 0)
                episodeName = str(episodeNumber).zfill(2)
                episodeTitle = episodeData.get('name', 'Titre Épisode Inconnu')
                saisonEpisodes.append(f"S{saisonName}E{episodeNumber} - {episodeTitle}")
            showEpisodes[x-1] = saisonEpisodes
    return ShowId, showName, showDate,showEpisodes

def getDefaultFolder():
    defaultFolder = Path("./") # Set the default folder path
    if len(sys.argv) > 1: # If an args is set
        givenFolder = Path(sys.argv[1]) # Create a folder from the given path
        if givenFolder.exists(): # If fiven folder exist
            defaultFolder = givenFolder # Set the given folder to default.
    return defaultFolder
def listAllFiles(Folder):
    videoExt = {".mkv", ".mp4", ".avi", ".mov", ".wmv"} # Listing all good extentions
    videoFiles = [f for f in Folder.iterdir() if f.suffix.lower() in videoExt] # Get all files with this extention.
    return videoFiles
def getInfoFromFile(File):
    fileName = File.name # Getting the file name
    fileName = re.sub(r'[\._\-]', ' ', fileName) # Remove unwanted char
    keyWords = r'(?i)\b(720p|1080p|2160p|4k|x264|x265|hevc|multi|french|truefrench|vff|vostfr|ac3|dts|bluray|webrip|hdtv|repack|crf24|xvid|aac)\b' # Listing all unwanted keywords
    fileName = re.sub(keyWords, '', fileName) # Removing unwanted keywords
    fileName = re.sub(r'-\w+$|\[.*?\]', '', fileName) # Removing team tags
    fileName = ".".join(fileName.split()) # Spliting name and joigning
    videoName, videoExtention = os.path.splitext(fileName) # Splitting filename for getting
    temp = re.split(r'\b(?:19|20)\d{2}\b', videoName) # Splitting name correctely
    videoName = temp[0].replace('.', ' ').strip() # Get parts of name
    temp = re.search(r'\b(19|20)\d{2}\b', fileName) # Recherche de la date
    videoYear = None # Set value by default
    if temp: # If date is found
        videoYear =  temp.group(0) # Set year to replace the default
    keyWords = r"(?:Saison[\s\.]?|S)(\d+)" # Listing all possibilities for the saison number
    match = re.search(keyWords, File.name, re.IGNORECASE) # Search a saison number in the filename
    videoSaison = None # Initializing saison number to None
    if match: # If a saison number was found
        videoSaison=match.group(1) # Extract saison number
    videoEpisode = None
    keyWords = r"(?:Episode[\s\.]?|E)(\d+)" # Listing all possibilities for episode number
    match = re.search(keyWords, File.name, re.IGNORECASE) # Search episode in name
    if match: # If a episode number is found
        videoEpisode = match.group(1) # Extract episode number
    return videoName.title(), videoYear, videoExtention.lower(), videoSaison, videoEpisode
def isTvShow(FileName):
    keyWords = r"(Saison|S)\d{1,2}" # Listing all saison keywords
    if re.search(keyWords.lower(), FileName.lower()): # If one of keyword is in the file
        return True
    return False
def getCredentialValue():
    file_path="/media/Runable/Docker/credentials.sh" # Define credentials path
    try:
        with open(file_path, 'r') as file: # Open file
            for line in file: # For each line
                line = line.strip() # Cleaning ligne
                if not line or line.startswith('#'): # If line is empty or start with "#"
                    continue # pass
                if line.startswith(f"TMDBApiToken="): # If the line is the token value
                    _, value = line.split('=', 1) # Split by the "="
                    return value.strip().strip('"').strip("'").strip() # return the value without '"' and "'"
    except FileNotFoundError:
        return "Erreur : Fichier introuvable."
    except Exception as e:
        return f"Erreur : {e}"
    return None
def callApi(url):
    API_BEARER_TOKEN=getCredentialValue() # Get token from file
    if not API_BEARER_TOKEN or len(API_BEARER_TOKEN)<200: # If token is not correct
        return "Erreur"
    headers = {"accept": "application/json", "Authorization": f"Bearer {API_BEARER_TOKEN}"} # Create the headers
    try:
        response = requests.get(url, headers=headers) #Send request and headers
        response.raise_for_status() # Wait the reply
        JsonResult = response.json() # Get the reply text
        return JsonResult # Return reply text
    except requests.RequestException as e:
        print(f"Erreur de requête API (callApi): {e}", file=sys.stderr)
        return False
def searchTvShow(VideoName, videoYear):
    url = f"https://api.themoviedb.org/3/search/tv?query={VideoName}&include_adult=false&language=fr-FR&page=1" # Creating the url of the API
    Results = callApi(url) # Call api with this URL
    if "results" in Results and Results['results']: # If result is not empty and result contain data
        Liste = [] # Creating list
        for result in Results['results']: # For each results
            showId = str(result.get('id', '')) # Get id form result
            showName = result.get('name', 'Titre Inconnu') # Get name from result
            temp = result.get('first_air_date', '0000') # Get first air date
            showYear = temp[:4] if temp else '0000' # Change fad to year
            Liste.append([showId, showName, showYear]) # Add to Liste
        List2 = []
        for result in Liste[:6]:
            if result[2] == videoYear:
                List2.append(result)
        if len(List2)==1:
            return List2[0]
        if len(Liste)>1:
            print(f"Plusieurs résultats ont été trouvés pour '{VideoName} ({videoYear})' : ")
            print("0 : Quitter.")
            print("1 : Saisir le nom manuellement.")
            for i in range(len(Liste)):
                print(f"{i+2} : {Liste[i][1]} ({Liste[i][2]}).")
            Select = input()
            if Select==0:
                return None
            elif Select>1 and Select<len(Liste)+2:
                return Liste[Select-2]
            else:
                VideoName = input()
                return searchTvShow(VideoName, videoYear)
main()
