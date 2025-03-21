-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
# منع حذف مكتبة AndroidX Window
-keep class androidx.window.** { *; }

# منع حذف Google ML Kit Vision
-keep class com.google.mlkit.** { *; }

# منع حذف مكتبة Jackson
-keep class com.fasterxml.jackson.databind.** { *; }

# منع حذف مكتبات XML
-keep class org.w3c.dom.** { *; }

# منع حذف Java Beans
-keep class java.beans.** { *; }

-keep class io.flutter.** { *; }
-keep class androidx.** { *; }
-keep class com.google.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.google.**
-dontwarn androidx.window.**
