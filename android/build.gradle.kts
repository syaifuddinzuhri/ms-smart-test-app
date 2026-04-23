allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

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
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension != null) {
            // 1. Paksa SEMUA module (termasuk kiosk_mode) menggunakan SDK 36
            // Ini kunci utama agar lStar dikenali saat build release
            try {
                val setter = androidExtension.javaClass.methods.firstOrNull {
                    it.name == "setCompileSdk" || it.name == "setCompileSdkVersion"
                }
                setter?.invoke(androidExtension, 36)
            } catch (e: Exception) { }

            // 2. Perbaikan Namespace (seperti sebelumnya)
            try {
                val getNamespace = androidExtension.javaClass.getMethod("getNamespace")
                val setNamespace = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                if (getNamespace.invoke(androidExtension) == null) {
                    val newNamespace = "com.${project.name.replace("-", ".")}"
                    setNamespace.invoke(androidExtension, newNamespace)
                }
            } catch (e: Exception) { }

            // 3. Paksa Java & Kotlin ke versi 11
            try {
                val compileOptions = androidExtension.javaClass.getMethod("getCompileOptions").invoke(androidExtension)
                compileOptions.javaClass.getMethod("setSourceCompatibility", JavaVersion::class.java).invoke(compileOptions, JavaVersion.VERSION_11)
                compileOptions.javaClass.getMethod("setTargetCompatibility", JavaVersion::class.java).invoke(compileOptions, JavaVersion.VERSION_11)
            } catch (e: Exception) { }
        }

        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinJvmCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
            }
        }
    }

    // 4. SOLUSI lStar: Paksa versi core ke 1.13.1
    // Versi ini sudah menyertakan definisi lStar secara default
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}