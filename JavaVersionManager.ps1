
function get-java-versions {
    Get-Content -Path $PSScriptRoot\java-versions.json -Encoding UTF8 | ConvertFrom-Json
}

function java-get-list {
    get-java-versions
    #number the output
}

function java-select-version {
   #Param(
   #[parameter(Mandatory=$true)][Int] $number=0
   #)
   $array = get-java-versions
   $java_version = $array[0]

   # extract variable from java_version
   $java_version | Get-Member -Name "path"
   #$env:Path += ";"
    #for now do a temporary add to the path if a interger is inputted in the method
        #later on add it to fixed to path
        #later on replace the java path with new path

 #output the list if empty
}


# use modules to privatize the functions you don't want to export
#EXTRA: output the path of the contents file