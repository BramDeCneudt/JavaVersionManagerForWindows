<#PSScriptInfo

.VERSION 0.0.2

.GUID 5a018c85-9cd8-4d54-9928-c9a846013829

.AUTHOR bramdecneudt@gmail.com

.COMPANYNAME N/A

.COPYRIGHT MIT license

.TAGS Java JavaHome JavaVersionManager

.LICENSEURI https://github.com/BramDeCneudt/JavaVersionManagerForWindows/blob/master/LICENSE

.PROJECTURI https://github.com/BramDeCneudt/JavaVersionManagerForWindows

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
Simple down to earth java version manager for windows.

This script will make it possible to easily switch between different java versions installed onto your Windows machine.

#> 

$prefix = "JVMFW_"
$java_version_file_name = "java-versions.json"
$debug = $false

#helper functions
function getObjectsFromFile {
    Param(
        [parameter(Mandatory = $true)][string] $fileName
    )
    Get-Content -Path $PSScriptRoot\$fileName -Encoding UTF8 | ConvertFrom-Json
}

function getUserEnvironmentVariable {
    Param(
        [parameter(Mandatory = $true)][string] $variableName
    )
    [Environment]::GetEnvironmentVariable($variableName, [System.EnvironmentVariableTarget]::User)
}

function setUserEnvironmentVariable {
    Param(
        [parameter(Mandatory = $true)][String] $variableName,
        [parameter(Mandatory = $true)][String] $newValue
    )
    [Environment]::SetEnvironmentVariable($variableName, $newValue, [System.EnvironmentVariableTarget]::User)
}

function setSystemEnvironmentVariable {
    Param(
        [parameter(Mandatory = $true)][String] $variableName,
        [parameter(Mandatory = $true)][String] $newValue
    )
    [Environment]::SetEnvironmentVariable($variableName, $newValue, [System.EnvironmentVariableTarget]::Machine)
}

function createFile {
    param (
        [parameter(Mandatory = $true)][String] $fileName
    )
    New-Item -Path $PSScriptRoot\$fileName -ItemType File 
}

function writeToLocalFile {
    param (
        [parameter(Mandatory = $true)][String] $fileName,
        [parameter(Mandatory = $true)][String] $message
    )
    $message | Out-File $PSScriptRoot/$fileName
}

function saveJsonToLocalFile {
    param (
        [parameter(Mandatory = $true)][String] $fileName,
        [parameter(Mandatory = $true)][Object] $object
    )
    ConvertTo-Json $object | Out-File $PSScriptRoot/$fileName
}

function fileExistsLocal {
    param (
        [parameter(Mandatory = $true)][String] $fileName
    )
    Test-Path $PSScriptRoot/$fileName -PathType Leaf
}

function java-get-list {
    $javaArray = getObjectsFromFile $java_version_file_name
    $javaArrayList = New-Object System.Collections.ArrayList(, $javaArray)
    return , $javaArrayList
}

function Select-JavaVersion {
    Param(
        [parameter(Mandatory = $false)][switch] $Init,
        [parameter(Mandatory = $false)][Int] $Path,
        [parameter(Mandatory = $false)][Int] $Home,
        [parameter(Mandatory = $false)][switch] $List,
        [parameter(Mandatory = $false)][String] $Add,
        [parameter(Mandatory = $false)][String] $Remove
    )

    if ($Init) {
        init
    }
    elseif ($PSBoundParameters.ContainsKey("Home") -and $PSBoundParameters.ContainsKey("Path")) {
        p "Setting home variable"
        set-java-home-version $Home
        p "Adding to java path"
        set-java-path-version $Path
    }
    elseif ($PSBoundParameters.ContainsKey("Home")) {
        set-java-home-version $Home
    }
    elseif ($PSBoundParameters.ContainsKey("Path")) {
        set-java-path-version $Path
    }
    elseif ($List) {
        java-get-indexed-list
    }
     
    elseif ($PSBoundParameters.ContainsKey("Add")) {
        add-to-java-list $Add
    }

    elseif ($PSBoundParameters.ContainsKey("Remove")) {
        remove-from-java-list $Remove
    }
    else {
        Write-Output "
Welcome to JavaVersionManagerForWindows!
If this is the first time starting this script you should initialize the script with the -Init command!
V0.0.2

Select-JavaVersion
[-Init]
Initializes the script for first time use, execute this one before all the other commands.

[-Home] <int>
Selects which java version you want to set as JAVA_HOME variable, needs an powershell with admin privilges.
You can chain this with -Path argument e.g. Java-SelectVersion -Path 0 -Home 0

[-Path] <int>
Selects which java version you want to add to path.
You can chain this with -Home argument e.g. Java-SelectVersion -Path 0 -Home 0

[-List]
Gives a list of all added java paths and their index Index you can use in the Index command.
                                        
[-Add] <string>
Adds a java path to the list must be in following pattern: java-name:C:\path\to\java. You cannot use a ':' in the java-name. e.g. 'oracleJava:C:\java\oracle\java'
This needs to be the java root path and not the bin path, bin path gets automatically appended when you use it in the -Path argument.

[-Remove] <int>
Removes the specified index from the list.
"
    }
}

function init {
    p "generating files for first time use"
    p "checking if file name $java_version_file_name already exist locally..."
    if (!(fileExistsLocal $java_version_file_name)) {
        createFile $java_version_file_name
        writeToLocalFile $java_version_file_name "[]"
    }
    else {
        p "*** file already exist, not creating the same file again ***"
    }

    p "finished generating files for first time use"
    p "enjoy the script!"
}

function set-java-home-version {
    param (
        [parameter(Mandatory = $True)][Int] $Index
    )
    $array = java-get-list
    $java_version = $array[$Index]
    $name = $java_version.name
    $path = $java_version.path


    p "Setting JAVA_HOME variable"
    setSystemEnvironmentVariable "JAVA_HOME" $path
}

function set-java-path-version {
    Param(
        [parameter(Mandatory = $True)][Int] $Index
    )
    $array = java-get-list
    $java_version = $array[$Index]
    $name = $java_version.name
    $path = $java_version.path
    $path = $path + "\bin"

    $oldPath = getUserEnvironmentVariable "Path"
    $previousJavaValue = getUserEnvironmentVariable $prefix"previousJavaValue"

    $newJavaValue = $oldPath + ";" + $path

    if (![String]::IsNullOrWhiteSpace($previousJavaValue)) {
        p "Found previous value, searching if it's contained in path"
        if ($oldPath.contains($previousJavaValue)) {
            p "Previous value is contained in path, replacing the value"
            $newJavaValue = $oldPath.replace($previousJavaValue, $path)
        }
        else {
            p "Previous value was not contained in path, appending to path"
        }
    }

    setUserEnvironmentVariable "Path" $newJavaValue
    setUserEnvironmentVariable $prefix"oldPath" $oldPath
    setUserEnvironmentVariable $prefix"previousJavaValue" $path

}

function java-get-indexed-list {
    $javaVersionObjects = java-get-list
    $newJavaVersionObjects = New-Object Collections.Generic.List[Object]
    $index = 0;
    foreach ($javaVersion in $javaVersionObjects) {
        #TODO needs better work around for getting the index column first, but works for now
        $newJavaVersion = New-Object -TypeName psobject
        $newJavaVersion | Add-Member -NotePropertyName index -NotePropertyValue $index
        $newJavaVersion | Add-Member -NotePropertyName name -NotePropertyValue $javaVersion.name
        $newJavaVersion | Add-Member -NotePropertyName path -NotePropertyValue $javaVersion.path
        $newJavaVersionObjects.add($newJavaVersion)
        $index++
    }
    $newJavaVersionObjects
}

function add-to-java-list {
    Param(
        [parameter(Mandatory = $True)][String] $NameAndPath
    )
    $Name, $Path = $NameAndPath.Split(":", 2);
    p "Adding following object to list"
    p  "Name: $Name" 
    p  "Path: $Path" 
    $javaObject = New-Object -TypeName psobject
    $javaObject | Add-Member -NotePropertyName name -NotePropertyValue $Name
    $javaObject | Add-Member -NotePropertyName path -NotePropertyValue $Path

    $newArray = java-get-list

    $newArray.add($javaObject)

    saveJsonToLocalFile $java_version_file_name $newArray
}

function remove-from-java-list {
    Param(
        [parameter(Mandatory = $True)][int] $index
    )
    $javaArray = java-get-list

    $javaArray.removeAt($index)

    saveJsonToLocalFile $java_version_file_name $javaArray
}

#logging
function p {
    Param(
        [parameter(Mandatory = $true)][string] $message
    )
    Write-Output $message
}

function pdebug {
    Param(
        [parameter(Mandatory = $true)][string] $message
    )
    if ($debug) {
        Write-Output $message
    }
}

function reloadEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 
}

Export-ModuleMember -Function Select-JavaVersion
