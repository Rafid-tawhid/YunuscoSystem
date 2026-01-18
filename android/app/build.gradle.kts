import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.system.yunusco_group"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.system.yunusco_group"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        // Use properties from flutter.properties or default values
        versionCode = (findProperty("flutter.versionCode") as? String)?.toIntOrNull() ?: 1
        versionName = findProperty("flutter.versionName") as? String ?: "1.0.0"
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            // Use release signing if properties file exists, otherwise use debug
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
            // NDK debug symbol configuration (if needed)
            ndk {
                // debugSymbolLevel is not available in current AGP versions
                // You can remove this block if not needed
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {

    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.2.0")  // Update Kotlin
    implementation("androidx.appcompat:appcompat:1.7.1")  // Add AppCompat
    implementation("com.google.android.material:material:1.13.0")  // Add Material
    // ... other dependencies
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")


}

flutter {
    source = "../.."
}
