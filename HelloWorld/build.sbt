ThisBuild / version := "1.0"
ThisBuild / scalaVersion := "2.12.16"
ThisBuild / organization := "com.pulserain"
ThisBuild / semanticdbEnabled := true
ThisBuild / semanticdbVersion := scalafixSemanticdb.revision


val spinalVersion = "1.8.0"
val spinalCore = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdslPlugin = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)


Compile / scalaSource := baseDirectory.value / "src" / "spinal"
Compile / unmanagedSourceDirectories += baseDirectory.value / "../common"
Compile / unmanagedSourceDirectories += baseDirectory.value / "test" / "spinal"

Test / scalaSource := baseDirectory.value / "test" / "spinal"

Compile / scalastyleSources := {
      val scalaSourceFiles = ((Compile / scalaSource).value ** "*.scala").get
      val otherSourceFiles = ((Compile / unmanagedSourceDirectories).value ** "*.scala").get
      
      scalaSourceFiles ++ otherSourceFiles.filterNot(_.getAbsolutePath.replaceAll("\\\\", "/").contains("test/spinal"))
}

libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdslPlugin)

fork := true

scalacOptions += "-deprecation"
scalacOptions += "-Ywarn-unused-import"
