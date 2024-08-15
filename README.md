[![Pub Version](https://img.shields.io/pub/v/badges?color=blueviolet)](https://pub.dev/packages/place_picker_google)
[![popularity](https://img.shields.io/pub/popularity/badges?logo=dart)](https://pub.dev/packages/place_picker_google/score)
[![likes](https://img.shields.io/pub/likes/badges?logo=dart)](https://pub.dev/packages/place_picker_google/score)

# Place Picker Google

A comprehensive, cross-platform google maps place picker library for Flutter.

The package provides common operations for Place picking, 
Places autocomplete, and Nearby places from google maps given you have enabled 
`Places API`, `Maps SDK for Android`, `Maps SDK for iOS` and `Geocoding API` for your API key.

<div style="display: flex;">
<img src="https://github.com/joafc96/place_picker_google/raw/main/assets/place_picker_google_light_mode.png" width="300">
<img src="https://github.com/joafc96/place_picker_google/raw/main/assets/place_picker_google_dark_mode.png" width="300">
</div>

## Setup

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  place_picker_google:  ^0.0.1
```

Now in your `Dart` code, you can use:
```dart
import 'package:place_picker_google/place_picker_google.dart';
```

## Getting Started

* Get an API key at <https://cloud.google.com/maps-platform/>.

* Enable Google Map SDK for each platform.
    * Go to [Google Developers Console](https://console.cloud.google.com/).
    * Choose the project that you want to enable Google Maps on.
    * Select the navigation menu and then select "Google Maps".
    * Select "APIs" under the Google Maps menu.
    * To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
    * To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
    * Make sure the APIs you enabled are under the "Enabled APIs" section.

* You can also find detailed steps to get started with Google Maps Platform [here](https://developers.google.com/maps/gmp-get-started).

### Android

Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

1. Set the `minSdkVersion` in `android/app/build.gradle`:

```groovy
android {
    defaultConfig {
        minSdkVersion 21
    }
}
```

This means that app will only be available for users that run Android SDK 21 or higher.

2. Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
    <application ...
        <!-- TODO: Add your Google Maps API key here -->
        <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR ANDROID KEY HERE"/>
        <activity ..../>
    </application>
</manifest>
```

### Note

The following permissions are not required to use Google Maps Android API v2, but are recommended.

`android.permission.ACCESS_COARSE_LOCATION` Allows the API to use WiFi or mobile cell data (or both) to determine the
device's location. The API returns the location with an accuracy approximately equivalent to a city block.

`android.permission.ACCESS_FINE_LOCATION` Allows the API to determine as precise a location as possible from the
available location providers, including the Global Positioning System (GPS) as well as WiFi and mobile cell data.

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

### iOS

Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```objectivec
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("YOUR KEY HERE")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Note

On iOS you'll need to add the following entries to your Info.plist file (located under ios/Runner) in order to access the device's location.

Simply open your Info.plist file and add the following:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location when open and in the background.</string>
```

## Contributing

Issues and PRs welcome. Unless otherwise specified, all contributions to this lib will be under MIT license.