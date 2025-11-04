# Keep Flutter's Play Store deferred component classes (safe even if unused)
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Keep Google Play SplitCompat and SplitInstall (prevents R8 missing class)
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.common.** { *; }

# Don't warn about missing Play Core classes (safe fallback)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
