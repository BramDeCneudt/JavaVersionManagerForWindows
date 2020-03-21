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
        java-get-list
    }
     
    elseif ($PSBoundParameters.ContainsKey("Add")) {
        #implement logic to add to the json file;
    }

    elseif ($PSBoundParameters.ContainsKey("Remove")) {
        #implement logic to remove from the json file;
    }
    else {
    echo "help should come here"
    }
}

function java-get-list {
    $javaVersionObjects = getObjectsFromFile "java-versions.json"
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
    $array = get-java-versions
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
