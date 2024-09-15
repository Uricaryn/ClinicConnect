# Flutter'ın temel kuralları

# Flutter'ın JNI yöntemlerini ve kütüphane yükleme işlemlerini küçültmeden koru
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Android giriş noktalarını korur
-keepclassmembers class * extends android.app.Activity { *; }
-keepclassmembers class * extends android.app.Application { *; }
-keepclassmembers class * extends android.content.BroadcastReceiver { *; }
-keepclassmembers class * extends android.content.ContentProvider { *; }
-keepclassmembers class * extends android.app.Service { *; }

# AndroidX ve Google Play hizmetlerini koru
-keep class androidx.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

# Parcelize ve serialization işlemlerini korur
-keep class **.R$* { *; }
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Kod küçültme sırasında refleksiyonla erişilen sınıfları korur
-keep class * implements java.io.Serializable { *; }

# Gson veya diğer JSON parsing kütüphanelerini kullanıyorsanız
-keep class com.google.gson.** { *; }
-keep class org.json.** { *; }
-keep class kotlinx.serialization.** { *; }

# Glide (image loading library) kullanıyorsanız
-keep class com.bumptech.glide.** { *; }
-keep class com.bumptech.glide.annotation.** { *; }
-keep class com.bumptech.glide.generated.** { *; }

# Firebase Analytics ve Crashlytics için gerekli kurallar
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod

# ProGuard'a özel Flutter ayarları
-keep public class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler

# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task