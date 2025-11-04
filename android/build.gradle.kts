import org.gradle.api.file.Directory

plugins {
    // 🔹 Plugins padrão do projeto
    // (se já houver outros, mantenha)
    id("com.google.gms.google-services")
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔹 Mantém o redirecionamento do diretório de build
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
