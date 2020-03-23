$prefix = "Wjvm_"

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


function java-select-version {
    Param(
        [parameter(Mandatory = $false)][Int] $Number,
        [parameter(Mandatory = $false)][switch] $List,
        [parameter(Mandatory = $false)][String] $Add,
        [parameter(Mandatory = $false)][String] $Remove
    )
    if ($PSBoundParameters.ContainsKey("Number")) {
        java-set-version $Number
    }

    elseif ($List) {
        java-get-indexed-list
    }
     
    elseif ($PSBoundParameters.ContainsKey("Add")) {
        add-to-java-list $Add
    }

    elseif ($PSBoundParameters.ContainsKey("Remove")) {
        #implement logic to remove from the json file;
    }
    else {
    echo "help should come here"
    }
}

function java-get-list {
#create a list here instead of a array
    $javaArray = getObjectsFromFile "java-versions.json"
    $javaArrayList = New-Object System.Collections.ArrayList(,$javaArray)
    return ,$javaArrayList
}

function add-to-java-list {
    Param(
        [parameter(Mandatory=$True)][String] $NameAndPath
    )
    $Name,$Path = $NameAndPath.Split(":");
    p "adding following to the list"
    p $Name
    p $Path
    $javaObject = New-Object -TypeName psobject
    $javaObject | Add-Member -NotePropertyName name -NotePropertyValue $Name
    $javaObject | Add-Member -NotePropertyName path -NotePropertyValue $Path

    $javaObject
    $newArray = java-get-list
    $newArray.add($javaObject)
    #make a save method of this
    $newArray | ConvertTo-Json | Out-File "$PSScriptRoot/java-versions.json"

}

function java-get-indexed-list {
    $javaVersionObjects = java-get-list
    $index = 0;
    foreach ($javaVersion in $javaVersionObjects) {
        $javaVersion | Add-Member -NotePropertyName index -NotePropertyValue $index
        $index++
    }
    $javaVersionObjects
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


    p $newValue
    setEnvironmentVariable "Path" $newValue
    setEnvironmentVariable $prefix"oldPath" $oldPath
    setEnvironmentVariable $prefix"previousValue" $path

}


function p {
    Param(
        [parameter(Mandatory = $true)][string] $message
    )
    echo $message
}

function reloadEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 
}

Export-ModuleMember -Function java-select-version
Export-ModuleMember -Function reloadEnv
