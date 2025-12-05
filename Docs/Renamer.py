import requests
import json
import os
import sys
import pyperclip

def GetShowIds(ShowBadTitle):
    url = "https://api.themoviedb.org/3/search/tv?query="+ShowBadTitle+"&include_adult=false&language=fr-FR&page=1"
    headers = {"accept": "application/json","Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjRkZDU2NThlYWNjN2JlZWFhNmMyMzBhZTEzMjRmNSIsInN1YiI6IjVlOTgwMTRlOWRlZmRhMDAxYWJiMmQ1MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._QX-7i11tjTW2xFO6i3KZgPQelYZK8Xs0aJ1tTKELrE"}
    response = requests.get(url, headers=headers)
    JsonEncoded = response.text
    Json = json.loads(JsonEncoded)
    if "results" in Json:
        Liste = [0]*len(Json['results'])
        for x in range(0,len(Json['results'])):
            Liste[x] = str(Json['results'][x]['id'])+":"+str(Json['results'][0]['name'])+" ("+str(Json['results'][x]['first_air_date'][0:4:1])+")"
        return Liste
    return False
def SelectShowId():
    ShowId = 0
    while ShowId==0:
        IdChoice=0
        BadName=""
        print("Nom de la série : ")
        BadName = input()
        ShowList = GetShowIds(BadName)
        if ShowList!=False and len(ShowList)>0:
            for x in range(0,len(ShowList)):
                print(str(x+1)+" : "+ShowList[x])
            print(str(len(ShowList)+1)+" : Autre")
            IdChoice = input()
            if IdChoice.isnumeric() and int(IdChoice) <= len(ShowList):
                ShowId = int(ShowList[int(IdChoice)-1][:ShowList[int(IdChoice)-1].find(":")])
    return ShowId
def SelectShowFolder():
    ShowFolder=""
    while len(ShowFolder)<2:
        IdChoice=0
        BadFolder=""
        print("Chemin du dossier : ")
        BadFolder = input()
        if not(BadFolder.endswith("/")):
            BadFolder = BadFolder+"/"
        SFolders = os.listdir(BadFolder)
        print(os.path.basename(BadFolder)+":")
        for SFolder in SFolders:
             if os.path.isdir(BadFolder + SFolder):
                print("--"+SFolder)
        print("Ce dossier est-il correct? o/n")
        IdChoice = input()
        if IdChoice.lower()=="o":
            ShowFolder = BadFolder
    return ShowFolder
def GetShowInfos(ShowId):
    url = "https://api.themoviedb.org/3/tv/"+str(ShowId)+"?language=fr-FR"
    headers = {"accept": "application/json","Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjRkZDU2NThlYWNjN2JlZWFhNmMyMzBhZTEzMjRmNSIsInN1YiI6IjVlOTgwMTRlOWRlZmRhMDAxYWJiMmQ1MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._QX-7i11tjTW2xFO6i3KZgPQelYZK8Xs0aJ1tTKELrE"}
    response = requests.get(url, headers=headers)
    JsonEncoded = response.text
    Json = json.loads(JsonEncoded)
    ShowSaison = Json["number_of_seasons"]
    ShowName = Json["name"]
    ShowDate = Json['first_air_date'][0:4:1]
    ShowEpisodes = GetShowEpisodes(ShowId,ShowSaison)
    return [ShowId,ShowName,ShowDate,ShowName+" ("+str(ShowDate)+")",ShowSaison,ShowEpisodes]
def GetShowEpisodes(ShowId,Saisons):
    Liste = [0]*Saisons
    for x in range(1, (Saisons+1)):
        if x < 10:
            SaisonName="0"+str(x)
        else:
            SaisonName=str(x)
        url = "https://api.themoviedb.org/3/tv/"+str(ShowId)+"/season/"+str(x)+"?language=fr-FR";
        headers = {"accept": "application/json","Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjRkZDU2NThlYWNjN2JlZWFhNmMyMzBhZTEzMjRmNSIsInN1YiI6IjVlOTgwMTRlOWRlZmRhMDAxYWJiMmQ1MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._QX-7i11tjTW2xFO6i3KZgPQelYZK8Xs0aJ1tTKELrE"}
        response = requests.get(url, headers=headers)
        JsonEncoded = response.text
        Json = json.loads(JsonEncoded)
        Ep = [0]*len(Json['episodes'])
        for y in range(0, len(Json['episodes'])):
            Episode = Json['episodes'][y]['episode_number']
            if Episode < 10:
                EpisodeName="0"+str(Episode)
            else:
                EpisodeName=str(Episode)
                
            Ep[y] = "S"+SaisonName+"E"+EpisodeName+" - "+Json['episodes'][y]['name']
        Liste[x-1] = Ep
        print("Saison "+SaisonName+": "+len(Liste[x-1]))
    return Liste
def SelectShowSaison(ShowInfos):
    Saison = 0
    while Saison==0:
        IdChoice=0
        print("Numero de saison (a pour toutes) : ")
        IdChoice = input()
        if IdChoice.lower()=="a":
            Saison=-1
        elif IdChoice.isnumeric() and int(IdChoice)<= int(ShowInfos[4]):
            Saison = IdChoice
    return Saison
def RenameSaisonFolder(ShowFolder):
    Saison = 0
    Files = os.listdir(ShowFolder)
    if not(ShowFolder.endswith("/")):
        ShowFolder = ShowFolder+"/"
    for File in Files:
        if os.path.isdir(ShowFolder + File):
            Saison +=1
    if Saison==0:
        os.mkdir(ShowFolder+"Saison 01")
        for File in Files:
            if not(os.path.isdir(ShowFolder + File)):
                os.rename(ShowFolder+File,ShowFolder+"Saison 01/"+File)
    else:
        Saison = 1
        for File in Files:
            if os.path.isdir(ShowFolder + File):
                if Saison<9:
                    os.rename(ShowFolder+File,ShowFolder+"Saisons 0"+str(Saison))
                else:
                    os.rename(ShowFolder+File,ShowFolder+"Saisons "+str(Saison))
                Saison +=1
def FileRename(ShowInfos,ShowFolder):
    if not(Path.endswith("/")):
        Path = Path+"/"
    Saisons = os.listdir(Path)
    for Saison in Saisons:
        if os.path.isdir(Path + Saison):
            Episodes = os.listdir(Path + Saison)
            for Episode in Episodes:
                if not(os.path.isdir(Path + Saison+"/"+Episode)):
                    Numerosaison = int(Saison[Saison.rfind(" ")+1:])
                    NumeroEpisode = int(Episode[:Episode.rfind(".")])
                    Extention = str(Episode[Episode.rfind(".")+1:])
                    Rename = ShowInfos[5][Numerosaison-1][NumeroEpisode-1]+"."+str(Extention)
                    Rename = Rename.replace("/", "-")
                    Rename = Rename.replace("\"", "")
                    Rename = Rename.replace(":", "-")
                    Rename = Rename.replace("?", "")
                    os.rename(Path+Saison+"/"+Episode,Path+Saison+"/"+Rename)
def DisplayHelp():
    print("Help")
           
def main():
    args = sys.argv[1:]
    if len(args)==0:
        ShowId = SelectShowId()
        ShowFolder = SelectShowFolder()
        ShowInfos = GetShowInfos(ShowId)
        ShowSaison = SelectShowSaison(ShowInfos)
        if int(ShowSaison)<0:
            RenameSaisonFolder(ShowFolder)
            FileRename(ShowInfos,ShowFolder)
        else:
            Episodes = os.listdir(ShowFolder)
            for Episode in Episodes:
                if not(os.path.isdir(ShowFolder+"/"+Episode)):
                    Numerosaison = int(ShowSaison)
                    NumeroEpisode = int(Episode[:Episode.rfind(".")])
                    Extention = str(Episode[Episode.rfind(".")+1:])
                    Rename = ShowInfos[5][Numerosaison-1][NumeroEpisode-1]+"."+str(Extention)
                    Rename = Rename.replace("/", "-")
                    Rename = Rename.replace(":", "-")
                    Rename = Rename.replace("?", "")
                    Rename = Rename.replace("\"", "")
                    os.rename(ShowFolder+"/"+Episode,ShowFolder+"/"+Rename)
        pyperclip.copy(ShowInfos[3])
    else:
        ShowId = 0
        ShowFolder = ""
        ShowSaison = 0
        for x in range(0,len(args)):
            if args[x].lower()=="-n" or args[x].lower()=="--name":
                Show = GetShowIds(args[x+1])[0]
                ShowId = Show[:Show.find(":")]
            elif args[x].lower()=="-p" or args[x].lower()=="--path":
                ShowFolder = args[x+1]
            elif args[x].lower()=="-s" or args[x].lower()=="--saison":
                ShowSaison = args[x+1]
        if int(ShowId)>0 and len(ShowFolder)>1:
            if ShowSaison==0:
                ShowSaison=-1
            ShowInfos = GetShowInfos(ShowId)
            if int(ShowSaison)<0:
                RenameSaisonFolder(ShowFolder)
                FileRename(ShowInfos,ShowFolder)
            else:
                Episodes = os.listdir(ShowFolder)
                for Episode in Episodes:
                    if not(os.path.isdir(ShowFolder+"/"+Episode)):
                        Numerosaison = int(ShowSaison)
                        NumeroEpisode = int(Episode[:Episode.rfind(".")])
                        Extention = str(Episode[Episode.rfind(".")+1:])
                        Rename = ShowInfos[5][Numerosaison-1][NumeroEpisode-1]+"."+str(Extention)
                        Rename = Rename.replace("/", "-")
                        Rename = Rename.replace(":", "-")
                        Rename = Rename.replace("?", "")
                        os.rename(ShowFolder+"/"+Episode,ShowFolder+"/"+Rename)
            pyperclip.copy(ShowInfos[3])
        else:
            DisplayHelp()
          
main()
