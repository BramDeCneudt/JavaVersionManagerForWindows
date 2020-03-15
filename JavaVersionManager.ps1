function getObjectsFromFile {
    Param(
    [parameter(Mandatory=$true)][string] $fileName
    )
    Get-Content -Path $PSScriptRoot\$fileName -Encoding UTF8 | ConvertFrom-Json
}


function get-java-versions {
    getObjectsFromFile "java-versions.json"
}

function java-get-list {
    get-java-versions

}

function get-settings {
    getObjectsFromFile "settings.json"
}

function save-settings {
#TODO implement further
}

function java-select-version {
   Param(
   [parameter(Mandatory=$true)][Int] $number
   )
   #TODO set a first time check up here for getting the settings
   $array = get-java-versions
   $java_version = $array[$number]
   $name = $java_version.name
   $path = $java_version.path
   #TODO backup used path to settings object


   $oldPath = [Environment]::GetEnvironmentVariable("Test", [System.EnvironmentVariableTarget]::User)
   #TODO backup old path to settings object
   p $oldPath.Contains($path)


   [Environment]::SetEnvironmentVariable('Test', $oldPath + ";"+ $path, [System.EnvironmentVariableTarget]::User)

}

function p {
    Param(
    [parameter(Mandatory=$true)][string] $message
    )
    echo $message
}

function testground {
    echo ([Environment]::GetEnvironmentVariable("Test", [System.EnvironmentVariableTarget]::User))
}


