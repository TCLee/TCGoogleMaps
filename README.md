#TCGoogleMaps

This sample project shows how we can use **Google Maps SDK for iOS**, **Google Places API**  and **Google Directions API** to build a simple navigation app.

<br>
*Search autocomplete with results sorted based on distance from your current location and relevance.*

!["Google Places Autocomplete"](http://tclee.github.io/TCGoogleMaps/images/Screenshot1.png "Google Places Autocomplete")

<br>
*Selecting a search result will give you the directions from your location to the selected destination.*  

!["Google Maps Directions"](http://tclee.github.io/TCGoogleMaps/images/Screenshot2.png "Google Maps Directions")

<br>
*Tapping on the list icon will bring up turn-by-turn directions.*

!["Turn-by-Turn Directions"](http://tclee.github.io/TCGoogleMaps/images/Screenshot3.png "Turn-by-Turn Directions")

<br>
*Selecting a step from the list will zoom in on that specific step on the map.*

!["Step-by-Step Directions on Map"](http://tclee.github.io/TCGoogleMaps/images/Screenshot4.png "Step-by-Step Directions on Map")

<br>
###How to Build and Run
<dl>
  <dt>Build Requirements</dt>
  <dd>Xcode 5, iOS 6.0 SDK or iOS 7.0 SDK, CocoaPods</dd>
  <dt>Runtime Requirements</dt>
  <dd>iOS 6.0 or iOS 7.0</dd>
</dl>

####Step 1: Download and Install CocoaPods

Follow the simple installation guide from <http://cocoapods.org/>.

####Step 2: Install Library Dependencies

Run the following commands in Terminal.app:  
```
$ cd <PROJECT_DIRECTORY>
$ pod install  
$ open TCGoogleMaps.xcworkspace
```

####Step 3: Generate your API Keys

1. Go to [Google API Console](https://code.google.com/apis/console/) and generate your API key.
2. In Xcode, open `TCGoogleMaps\App\TCGoogleAPIKeys.m` and replace with your own API key:
  
  ```Objective-C
  NSString * const kTCGoogleMapsAPIKey = @"YOUR-API-KEY";
  NSString * const kTCGooglePlacesAPIKey = @"YOUR-API-KEY";
  ```

###Open Source Libraries Used
* AFNetworking - <https://github.com/AFNetworking/AFNetworking>
* MBProgressHUD - <https://github.com/jdg/MBProgressHUD>

###See Also
* Google Maps SDK for iOS - <https://developers.google.com/maps/documentation/ios/>
* Google Places API - <https://developers.google.com/places/>
* Google Directions API - <https://developers.google.com/maps/documentation/directions/>

###License
This project's source code is provided for educational purposes only. Image resources are based on the icons used in Google Maps. See the LICENSE file for more info.
