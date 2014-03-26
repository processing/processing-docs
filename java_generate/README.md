Documentation for Java-Generate
===============================

Java-generate is built on top of Javadoc in order to semi-automate the
generation of Processing's documentation for distribution and the web.

Since it uses Javadoc, we need to be able to find the Processing source
code. If you clone both Processing and Processing-Web to the same directory,
you should be good to go.

In other words, the two repositories should live side-by-side:

- base_dir/processing/
- base_dir/processing-web/

### Running java-generate
The documentation is build using a command-line script.
```
$ cd ReferenceGenerator/
$ ./processingrefBuild.sh
```

### Building the Java-Generate classes

Java-generate is compiled using ant, which is likely already installed on your machine.
To build the reference generator

```bash
$ cd ReferenceGenerator/
$ ant compile
```

For more information on ant, see http://ant.apache.org

If you have trouble compiling with ant, you may need to install the JDK on your machine
and add a JAVA_HOME environment variable to your machine. Properly locating your JDK is
essential for handling issues like importing the javadoc package.

On OSX (Mavericks), that will look like the following:
```bash
# in e.g. ~/.bash_profile
# tell Java where to find JDK and libraries
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
```

### Tips & Tricks

When a method is overloaded, but you don't want one of the variants to appear in the reference, add a `@nowebref` comment to the source above that variant.  For example:

```java
/**
  * @nowebref
  */
```