#           _____                    _____                   _______                  _______               _____          
#          /\    \                  /\    \                 /::\    \                /::\    \             /\    \         
#         /::\    \                /::\    \               /::::\    \              /::::\    \           /::\    \        
#        /::::\    \              /::::\    \             /::::::\    \            /::::::\    \          \:::\    \       
#       /::::::\    \            /::::::\    \           /::::::::\    \          /::::::::\    \          \:::\    \      
#      /:::/\:::\    \          /:::/\:::\    \         /:::/~~\:::\    \        /:::/~~\:::\    \          \:::\    \     
#     /:::/  \:::\    \        /:::/__\:::\    \       /:::/    \:::\    \      /:::/    \:::\    \          \:::\    \    
#    /:::/    \:::\    \      /::::\   \:::\    \     /:::/    / \:::\    \    /:::/    / \:::\    \         /::::\    \   
#   /:::/    / \:::\    \    /::::::\   \:::\    \   /:::/____/   \:::\____\  /:::/____/   \:::\____\       /::::::\    \  
#  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\____\ |:::|    |     |:::|    ||:::|    |     |:::|    |     /:::/\:::\    \ 
# /:::/____/  ___\:::|    |/:::/  \:::\   \:::|    ||:::|____|     |:::|    ||:::|____|     |:::|    |    /:::/  \:::\____\
# \:::\    \ /\  /:::|____|\::/   |::::\  /:::|____| \:::\    \   /:::/    /  \:::\    \   /:::/    /    /:::/    \::/    /
#  \:::\    /::\ \::/    /  \/____|:::::\/:::/    /   \:::\    \ /:::/    /    \:::\    \ /:::/    /    /:::/    / \/____/ 
#   \:::\   \:::\ \/____/         |:::::::::/    /     \:::\    /:::/    /      \:::\    /:::/    /    /:::/    /          
#    \:::\   \:::\____\           |::|\::::/    /       \:::\__/:::/    /        \:::\__/:::/    /    /:::/    /           
#     \:::\  /:::/    /           |::| \::/____/         \::::::::/    /          \::::::::/    /     \::/    /            
#      \:::\/:::/    /            |::|  ~|                \::::::/    /            \::::::/    /       \/____/             
#       \::::::/    /             |::|   |                 \::::/    /              \::::/    /                            
#        \::::/    /              \::|   |                  \::/____/                \::/____/                             
#         \::/____/                \:|   |                   ~~                       ~~                                   
#  
#
<#
    Le 02/11/2023 - Gregory EL BAJOURY
   .DESCRIPTION
    Ce script se connecte à l'API de PRTG Network Monitor en utilisant une URL de serveur, un nom d'utilisateur et un hash de mot de passe. 
    Il récupère les informations sur les appareils surveillés (tels que ID, nom, groupe et hôte) et les exporte dans un fichier CSV. 
    Le script utilise des paramètres prédéfinis pour la connexion et la récupération des données, et supporte une sortie personnalisée au format CSV.

    .PARAMETERS
    PRTGServer: URL du serveur PRTG.
    UserName: Nom d'utilisateur pour accéder à l'API PRTG.
    Passhash: Hash de mot de passe pour l'authentification API.

    .FUNCTIONS
    Get-PRTGDevices: Récupère les détails des appareils depuis l'API PRTG.
    Export-DevicesToCSV: Exporte la liste des appareils dans un fichier CSV.
    Main: Fonction principale orchestrant les opérations du script.

    .EXAMPLE
    Pour exécuter ce script, utilisez simplement la commande `.\nom_du_script.ps1` dans PowerShell. Assurez-vous que les paramètres de connexion sont correctement définis.
#>

# Paramètres de connexion au serveur PRTG
param(
    [string]$PRTGServer = "https://votreserveurPRTG", # URL du serveur PRTG
    [string]$UserName = "votreUtilisateur",            # Nom d'utilisateur pour accéder à l'API PRTG
    [string]$Passhash = "votrePasshash"           # Hash de mot de passe pour l'authentification API
)

# Fonction pour récupérer les appareils depuis l'API PRTG
function Get-PRTGDevices {
    param (
        [string]$Server,    # URL du serveur PRTG
        [string]$Username,  # Nom d'utilisateur pour l'API
        [string]$Passhash   # Hash de mot de passe pour l'API
    )

    # Construction de l'URL pour la requête API
    $ApiUri = "$Server/api/table.json?content=devices&output=json&columns=objid,device,group,host&username=$Username&passhash=$Passhash"

    try {
        # Appel API et récupération des données
        $Response = Invoke-RestMethod -Uri $ApiUri -Method Get -ErrorAction Stop
        # Tri des appareils par ordre alphabétique de leur nom et retour des résultats
        return $Response.devices | Sort-Object device
    } catch {
        # Gestion des erreurs lors de l'appel API
        Write-Error "Erreur lors de l'appel API a PRTG : $_"
        exit
    }
}


# Fonction pour exporter les appareils vers un fichier CSV
function Export-DevicesToCSV {
    param (
        [Array]$Devices,        # Liste des appareils à exporter
        [string]$OutputFilePath # Chemin du fichier CSV de sortie
    )
    
    # Exportation des appareils vers un fichier CSV
    $Devices | ForEach-Object {
        # Création d'un objet personnalisé pour chaque appareil
        [PSCustomObject]@{
            "ID Appareil" = $_.objid
            "Appareil"    = $_.device
            "Groupe"      = $_.group
            "Hote"        = $_.host
        }
    } | Export-Csv -Path $OutputFilePath -NoTypeInformation -Delimiter ";" -Encoding UTF8
}

# Fonction principale
function Main {
    # Format de la date au format jour-mois-année et ajout de l'heure
    $DateTimeFormat = (Get-Date -Format "dd-MM-yyyy-HH-mm")
    # Construction du nom de fichier avec la date et l'heure
    $OutputFile = "$HOME\PRTG-Export-$DateTimeFormat.csv"

    # Vérification de la présence de tous les paramètres requis
    if (-not $PRTGServer -or -not $UserName -or -not $Passhash -or -not $OutputFile) {
        Write-Host "Tous les parametres sont obligatoires." -ForegroundColor Red
        return
    }

    # Début du processus d'extraction
    Write-Host "Debut de l'extraction de la liste des equipements de PRTG..."
    # Récupération des appareils depuis PRTG
    $Devices = Get-PRTGDevices -Server $PRTGServer -Username $UserName -Passhash $Passhash
    # Exportation des appareils vers un fichier CSV
    Export-DevicesToCSV -Devices $Devices -OutputFilePath $OutputFile

    # Confirmation de l'exportation réussie
    Write-Host "La liste des equipements a ete exportee avec succes vers $OutputFile"

    # Ouverture du fichier CSV dans Excel
    # Start-Process -FilePath $OutputFile
}

# Exécution du script
Main

