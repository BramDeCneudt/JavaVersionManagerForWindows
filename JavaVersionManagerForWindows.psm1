$prefix = "Wjvm_"
$java_version_file_name = "java-versions.json"
$debug = $false

#helper functions
function getObjectsFromFile {
    Param(
        [parameter(Mandatory = $true)][string] $fileName
    )
    Get-Content -Path $PSScriptRoot\$fileName -Encoding UTF8 | ConvertFrom-Json
}

function getEnvironmentVariable {
    Param(
        [parameter(Mandatory = $true)][string] $variableName
    )
    [Environment]::GetEnvironmentVariable($variableName, [System.EnvironmentVariableTarget]::User)
}

function setEnvironmentVariable {
    Param(
        [parameter(Mandatory = $true)][String] $variableName,
        [parameter(Mandatory = $true)][String] $newValue
    )
    [Environment]::SetEnvironmentVariable($variableName, $newValue, [System.EnvironmentVariableTarget]::User)
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

function java-select-version {
    Param(
        [parameter(Mandatory = $false)][switch] $Init,
        [parameter(Mandatory = $false)][Int] $Number,
        [parameter(Mandatory = $false)][switch] $List,
        [parameter(Mandatory = $false)][String] $Add,
        [parameter(Mandatory = $false)][String] $Remove
    )

    if ($Init) {
        init
    }
    elseif ($PSBoundParameters.ContainsKey("Number")) {
        java-set-version $Number
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
V0.0.1

java-select-version
[-Init]              initializes the script for first time use, execute this one before all the other commands

[-Number] <int>	    selects which java version you want to add to path

[-List]             gives a list of all added java paths and their index number you can use in the number command
                                        
[-Add] <string>	    adds a java path to the list must be in following pattern: java-name:c/path/to/bin, you cannot use a ':' in the java-name. e.g. 'oracleJava:c:/java/oracle/java/bin'

[-Remove] <int> 	removes the specified index from the list
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

function java-set-version {
    Param(
        [parameter(Mandatory = $True)][Int] $Number
    )
    $array = java-get-list
    $java_version = $array[$number]
    $name = $java_version.name
    $path = $java_version.path

    $oldPath = getEnvironmentVariable "Path"
    $oldValue = getEnvironmentVariable $prefix"previousValue"

    p $oldPath

    $newValue = $oldPath + ";" + $path

    if (![String]::IsNullOrWhiteSpace($oldValue)) {
        p "non empty value, seeing if it is contained in the path"
        if ($oldPath.contains($oldValue)) {
            p "oldvalue is contained in oldpath, replacing the value"
            $newValue = $oldPath.replace($oldValue, $path)
        }
        else {
            p "found oldvalue but was not contained in path"
        }
    }

    setEnvironmentVariable "Path" $newValue
    setEnvironmentVariable $prefix"oldPath" $oldPath
    setEnvironmentVariable $prefix"previousValue" $path

}

function java-get-indexed-list {
    $javaVersionObjects = java-get-list
    $newJavaVersionObjects = New-Object Collections.Generic.List[Object]
    $index = 0;
    foreach ($javaVersion in $javaVersionObjects) {
        #needs better work around for getting the index column first, but works for now
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
    p  "name: $Name" 
    p  "path: $Path" 
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

Export-ModuleMember -Function java-select-version
Export-ModuleMember -Function reloadEnv
