
function get-java-versions {
    Get-Content -Path $PSScriptRoot\java-versions.json -Encoding UTF8 | ConvertFrom-Json
}

function java-get-list {
    get-java-versions
    #number the output
}

function java-select-version {
   Param(
   [parameter(Mandatory=$true)][Int] $number
   )
   $array = get-java-versions
   $java_version = $array[$number]
   $name = $java_version.name
   $path = $java_version.path

   p $env:Path.Contains($path)

   [Environment]::SetEnvironmentVariable('Test', $path, [System.EnvironmentVariableTarget]::User)
   #$env:Path += ";" + $path;
        # choose if you want to add to user path (non-admin) or system/machine path (admin)
            # for now will just use user path
        #later on replace the old java path with the new path
            # you will need to save the last path to a settings file
                # if the last saved path is not present in env path just append it
        #later on add it to fixed to path


 #output the list if empty, with numbers
}

function p {
    Param(
    [parameter(Mandatory=$true)][string] $message
    )
    echo $message
}

function testground {
    [Environment]::SetEnvironmentVariable('Test', 'test', [System.EnvironmentVariableTarget]::Machine)
}



# use modules to privatize the functions you don't want to export
#EXTRA: output the path of the contents file