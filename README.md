# JavaVersionManagerForWindows

Simple down to earth java version manager for windows. 

This script will make it possible to easily switch between different java versions installed onto your Windows machine.

You will still need to install the different versions of java onto your machine and add them to the script, the script only handles changes to the env path.

This script won't work if you have a java version path on System level, remove this one first otherwise the script won't work.

# Installation

* Open a powershell session with admin privileges 
* input following command in the session:
  `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`
  This will make it possible to execute this script but also other script you download, so watch out with this!
* Go to `%UserProfile%\Documents\WindowsPowerShell\Modules` ,if it doesn't exist yet create the directory.
* clone this repository into the above mentioned directory
* Open a new powershell session and check if following commands works `Select-JavaVersion`
* before you can use the script you first need to init the script for first time use, by executing following command: `Select-JavaVersion -init`

Congratulations you can now use the script!

# Commands

`Select-JavaVersion`

```
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
```



# Examples



## Change the JAVA_HOME variable and Java version path at the same time

You can easily change the JAVA_HOME variable and the java version on you path in one go!

### Initialize  the script

First you want to do is initialize the script if you haven't already :
`Select-JavaVersion init`

### Adding the java paths to the script

When that is done you can add the java version paths to the script:

command format: `Select-JavaVersion -Add "javaName:c:\path\to\java"`

* `Select-JavaVersion -Add "adoptjdk8:C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot"`
* `Select-JavaVersion -Add "adoptjdk11:C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot"`

You can than verify that they have been added to the script by checking if they are listed:
`Select-JavaVersion -List`

should give this output:

----- ----       ----
```powershell
index name       path
----- ----       ----
    0 adoptjdk8  C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot
    1 adoptjdk11 C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot
```



### Changing JAVA_HOME and Java version path

Now you can easily change JAVA_HOME and Java version path:

* `Select-JavaVersion -Path 0 -Home 0` if you want to use the adoptJDK 8 for JAVA_HOME and Java version on path



## Adding multiple java paths to the script

For example you have following java versions installed on your computer that you want to frequently change on path:

* name: adopjdk8 path: C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot
* name: adoptjdk11 path: C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot
* name: zulu14 path: C:\Program Files\Zulu\zulu-14



### Initialize  the script

First you want to do is initialize the script if you haven't already :
`Select-JavaVersion init`

### Adding the java paths to the script

When that is done you can add the java version paths to the script:

command format: `Select-JavaVersion -Add "javaName:c:\path\to\java"`

* `Select-JavaVersion -Add "adoptjdk8:C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot"`
* `Select-JavaVersion -Add "adoptjdk11:C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot"`
* `Select-JavaVersion -Add "zulu14:C:\Program Files\Zulu\zulu-14"`

you can than verify that they have been added to the script by checking if they are listed:
`Select-JavaVersion -List`

should give this output:

----- ----       ----
```powershell
index name       path
----- ----       ----
    0 adoptjdk8  C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot
    1 adoptjdk11 C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot
    2 zulu14     C:\Program Files\Zulu\zulu-14
```
### Change between java paths

Now you can easily change between different java version by doing following:

* `Select-JavaVersion -Path 0` if you want to use the adoptJDK 8

```powershell
openjdk version "1.8.0_242"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_242-b08)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.242-b08, mixed mode)
```

* `Select-JavaVersion -Path 1` if you want to use the adoptJDK 11

```powershell
openjdk version "11.0.6" 2020-01-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.6+10)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.6+10, mixed mode)
```

* `Select-JavaVersion -Path 2` if you want to use zulu 14

```powershell
openjdk version "14" 2020-03-17
OpenJDK Runtime Environment Zulu14.27+1-CA (build 14+36)
OpenJDK 64-Bit Server VM Zulu14.27+1-CA (build 14+36, mixed mode, sharing)
```

This won't work if you have a java version path on System level, remove this one first otherwise the script won't work.

Don't forget to create a new PowerShell session before you can use the new java version.

****



# TODO

* Home variable should also work without having an admin session, it will ask for admin privilege's if needed
