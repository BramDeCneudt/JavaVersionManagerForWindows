$prefix = "Wjvm_"

function getObjectsFromFile {
    Param(
    [parameter(Mandatory=$true)][string] $fileName
    )
    Get-Content -Path $PSScriptRoot\$fileName -Encoding UTF8 | ConvertFrom-Json
}

function getEnvironmentVariable {
    Param(
    [parameter(Mandatory=$true)][string] $variableName
    )
    [Environment]::GetEnvironmentVariable($variableName, [System.EnvironmentVariableTarget]::User)
}

function setEnvironmentVariable {
    Param(
    [parameter(Mandatory=$true)][String] $variableName,
    [parameter(Mandatory=$true)][String] $newValue
    )
   [Environment]::SetEnvironmentVariable($variableName, $newValue, [System.EnvironmentVariableTarget]::User)
}


function get-java-versions {
    getObjectsFromFile "java-versions.json"
}

function java-get-list {
    get-java-versions
}

function java-select-version {
   Param(
   [parameter(Mandatory=$true)][Int] $number
   )
   $array = get-java-versions
   $java_version = $array[$number]
   $name = $java_version.name
   $path = $java_version.path

   $oldPath = getEnvironmentVariable "Path"
   $oldValue = getEnvironmentVariable $prefix"previousValue"

   p $oldPath

   $newValue = $oldPath + ";"+ $path

   if (![String]::IsNullOrWhiteSpace($oldValue)) {
        p "non empty value, seeing if it is contained in the path"
        if ($oldPath.contains($oldValue)) {
        p "oldvalue is contained in oldpath, replacing the value"
                $newValue = $oldPath.replace($oldValue, $path)
        } else  {
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
    [parameter(Mandatory=$true)][string] $message
    )
    echo $message
}

function testground {
    echo ([Environment]::GetEnvironmentVariable("Test", [System.EnvironmentVariableTarget]::User))
}

function reloadEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
    $env:Test = getEnvironmentVariable "Test"
}

Export-ModuleMember -Function java-select-version


