# JavaVersionManagerForWindows

Simple down to earth java version manager for windows. 

This script will make it possible to easily switch between different java versions installed onto your Windows machine.

 **Disclaimer:** you will still need to install the different versions of java onto your machine and add them to the script, the script only handles changes to the class path.

**This script won't work if you have a java version path on System level, remove this one first otherwise the script won't work**

# Installation

* Open a powershell session with admin privileges 
* input following command in the session:
  `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`
  This will make it possible to execute this script but also other script you download, so watch out with this!
* Go to `%UserProfile%\Documents\WindowsPowerShell\Modules` ,if it doesn't exist yet create the directory.
* clone this repository into the above mentioned directory
* Open a new powershell session and check if following commands works `java-select-version`
* before you can use the script you first need to init the script for first time use, by executing following command: `java-select-version -init`

Congratulations you can now use the script!

# Commands

`java-select-version`

	`[-Init]`	
	Initializes the script for first time use, execute this one before all the other commands

	`[-Number] <int>`	
	Selects which java version you want to add to path

 	`[-List]`	
	Gives a list of all added java paths and their index number you can use in the number command

	`[-Add] <string>`		
	Adds a java path to the list must be in following pattern: java-name:c/path/to/bin, you cannot use a ':' in the java-name. e.g. "oracleJava:c:/java/oracle/java/bin"

	`[-Remove] <int>` 	
	Removes the specified index from the list



# Examples



## Adding multiple java paths to the script

For example you have following java versions installed on your computer that you want to frequently change on path:

* name: adopjdk8 path: C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot\bin
* name: adoptjdk11 path: C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot\bin
* name: zulu14 path: C:\Program Files\Zulu\zulu-14\bin



### Init the script

first you want to do is init the script if you haven't already :
`java-select-version init`

### Adding the java paths to the script

when that is done you can add the java version paths to the script:

command format: `java-select-version -Add "javaName:c:/path/to/java/bin"`

* `java-select-version -Add "adoptjdk8:C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot\bin"`
* `java-select-version -Add "adoptjdk11:C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot\bin"`
* `java-select-version -Add "zulu14:C:\Program Files\Zulu\zulu-14\bin"`

you can than verify that they have been added to the script by checking if they are listed:
`java-select-version -List`

should give this output:

----- ----       ----
```powershell
index name       path
----- ----       ----
    0 adoptjdk8  C:\Program Files\AdoptOpenJDK\jdk-8.0.242.08-hotspot\bin
    1 adoptjdk11 C:\Program Files\AdoptOpenJDK\jdk-11.0.6.10-hotspot\bin
    2 zulu14     C:\Program Files\Zulu\zulu-14\bin
```
### Change between java paths

Now you can easily change between different java version by doing following:

* `java-select-version -Number 0` if you want to use the adoptJDK 8

```powershell
openjdk version "1.8.0_242"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_242-b08)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.242-b08, mixed mode)
```

* `java-select-version -Number 1` if you want to use the adoptJDK 11

```powershell
openjdk version "11.0.6" 2020-01-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.6+10)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.6+10, mixed mode)
```

* `java-select-version -Number 2` if you want to use zulu 14

```powershell
openjdk version "14" 2020-03-17
OpenJDK Runtime Environment Zulu14.27+1-CA (build 14+36)
OpenJDK 64-Bit Server VM Zulu14.27+1-CA (build 14+36, mixed mode, sharing)
```

**This won't work if you have a java version path on System level, remove this one first otherwise the script won't work**

**Don't forget to create a new Powershell session before you can use the new java version**

****



# TODO

* refactor variable naming and function naming
* write command to replace java versions on JAVA_HOME

