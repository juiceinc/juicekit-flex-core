This is the JuiceKit Core library.

This file supports building the library in Intellij IDEA, Flash Builder 4 and Maven. This library targets
Flex 4.1.

# File structure

src/
	main/
		flex/  -- JuiceKit core library code
	test/
		flex/  -- JuiceKit core Flex4 unit tests
		          The unit tests can be run most easily in Intellij.

scripts/
	-- Contains scripts to generate documentation using asdoc




# Using JuiceKit core in Flash Builder

To use the library from source, In your workspace, clone the juicekit-flex-core repository.

$ cd {your workspace}
$ git clone git@github.com:chrisgemignani/juicekit-flex-core.git


# Intellij IDEA


# Maven

Instructions to use juicekit-flex-core as a dependency in a Maven-based project are coming
soon.

## To compile with Maven

	$ mvn compile
	[INFO] Scanning for projects...
	[INFO] ------------------------------------------------------------------------
	[INFO] Building JuiceKit Flex Core Library
	[INFO]    task-segment: [compile]
	[INFO] ------------------------------------------------------------------------
	...
	...
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESSFUL
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 41 seconds
	[INFO] Finished at: Tue Aug 10 13:01:57 EDT 2010
	[INFO] Final Memory: 34M/411M
	[INFO] ------------------------------------------------------------------------

## To build asdocs

Ensure you have the asdoc tool on your $PATH. From the main directory:

$ ./scripts/docs.bash
Run from the main directory of juicekit-flex-core to generate asdocs

Output will be generated in target/asdoc-output/
Loading configuration file /Applications/Adobe Flash Builder 4/sdks/4.1.0/frameworks/flex-config.xml



# How to do a release

* Set the appropriate version number in pom.xml
* Open the project in IntelliJ.
* Navigate to /src/test/flex/org.juicekit/UtilTestSuite.as. Right click and select run UtilTestSuite.
All tests must pass.
* Run "mvn install" either from the command line or in Intellij "Maven Projects > Lifecycle" view.
* Run "mvn deploy"
* Tag the build in git.
* Update the version number in pom.xml to x.x.x-SNAPSHOT

# How to ensure you have the latest version