#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
# Firebase Database
-keep class com.google.firebase.database.** { *; }

# Firebase Authentication
-keepnames class com.google.firebase.auth.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-keep class com.google.android.gms.** { *; }
-keepnames class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
-keepnames class com.google.firebase.** { *; }
-keepattributes Signature

# AppLovin MAX
-keep class com.applovin.mediation.** { *; }
-keep class com.applovin.sdk.** { *; }
-keep class com.applovin.nativeAds.** { *; }
-keep class com.applovin.adview.** { *; }
-keep class com.applovin.impl.sdk.** { *; }
-keep class com.applovin.mediation.adapters.** { *; }
-keep class com.applovin.mediation.adapter.listeners.** { *; }

-keepattributes SourceFile,LineNumberTable

-dontwarn com.applovin.**
