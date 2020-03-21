# JavaVersionManagerForWindows
Simple down to earth java version manager for windows.

# TODO

* refactor variable naming and function naming
* number the output from get-java-versions and put it in the java-get-list function
* choose if you want to add to user path (non-admin) or system/machine path (admin)
	
  * for now will just use user path
* later on replace the old java path variable with the new path
  * you will need to save the last path variabel to a settings file
  
  * if the last saved path is not present in env path just append it
* output the list if empty, with numbers
* use modules to privatize the functions you don't want to export ~
* EXTRA: output the path of the contents file
* fix gitignore and ignored files
* write guide and how to install it as a module

