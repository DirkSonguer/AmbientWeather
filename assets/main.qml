// *************************************************** //
// Main Page
//
// This is the main page of the AmbientWeather application
// It contains the main page components as well as the
// orchestration locig.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// import geolocation services
import QtMobilitySubset.location 1.1

// import url loader workaround
import org.labsquare 1.0

// set import directory for components
import "components"

// shared js files
import "global/globals.js" as Globals
import "classes/flickrapi.js" as FlickrAPI
import "classes/locationapi.js" as LocationAPI
import "classes/weatherapi.js" as WeatherAPI
import "classes/locationmanager.js" as LocationManager
import "structures/geolocationdata.js" as GeolocationData

NavigationPane {
    id: navigationPane

    Page {
        id: ambientWeatherMainPage

        // property for the current geolocation
        // contains lat and lon
        property variant currentGeolocation

        // property for the weather for current location
        // this is of type LocationData
        property variant currentWeatherdata

        // the current search radius for images
        // this might change dynamically if no images are found and the radius is widened
        property real currentLocationSearchRadius: Globals.locationSearchRadius

        // flickr api signals
        signal imageDataLoaded(variant imageDataArray)
        signal imageDataError(variant errorData)

        // weather api signals
        signal weatherDataLoaded(variant weatherData)
        signal weatherDataError(variant errorData)

        // change location signal
        // this will be called by other pages if a new location should be used
        signal changeLocation(variant locationData)

        Container {
            layout: DockLayout {
            }

            // background image
            // the component also contains the logic for changing images and their transitions
            BackgroundImage {
                id: backgroundImage
            }

            // weather dashboard
            // this contains all components for showing weather data and icons
            WeatherDashboard {
                id: weatherDashboard

                // bottom padding is dynamic according to screen size
                bottomPadding: (DisplayInfo.height / 10)
                rightPadding: 20
            }

            // context menu for image gallery
            contextActions: [
                ActionSet {
                    title: "Ambient Weather"
                    subtitle: "Where are you?"

                    // use current location
                    ActionItem {
                        title: "Use my current location"
                        imageSource: "asset:///images/icon_currentlocation.png"

                        // action called
                        onTriggered: {
                            console.log("# Getting current location");

                            // stop position query just to make sure it doesn't run anymore
                            positionSource.stop();

                            // reset information labels
                            weatherDashboard.weatherLocation = "Ambient Weather";
                            weatherDashboard.weatherCondition = "Getting your position..";

                            // reset the current location if one was previously set
                            LocationManager.resetActiveLocation();

                            // start getting location
                            positionSource.start();
                        }
                    }
                    // change current location from manual list
                    ActionItem {
                        title: "Choose location manually"
                        imageSource: "asset:///images/icon_managelocation.png"

                        // switch to location list page
                        onTriggered: {
                            var locationManagementPage = locationManagementComponent.createObject();
                            navigationPane.push(locationManagementPage);
                        }
                    }
                }
            ]
        }

        // app is loaded and page is available
        onCreationCompleted: {
            // loading default image
            backgroundImage.showLocalImage("asset:///images/ambient_weather_intro.jpg");

            //  get  available, stored locations
            var activeLocation = new Array;
            activeLocation = LocationManager.getActiveLocation();

            // check if an active location is set
            if (activeLocation.display_name != null) {
                console.log("# Using active location " + activeLocation.display_name);

                // reset weather background image and dashboard
                backgroundImage.showLocalImage("asset:///images/ambient_weather_intro.jpg");
                weatherDashboard.resetDashboard();

                // create geolocation object and fill it with location data
                var locationCoordinates = new GeolocationData.GeolocationData;
                locationCoordinates.latitude = activeLocation.lat;
                locationCoordinates.longitude = activeLocation.lon;

                // set location data and load weather data
                ambientWeatherMainPage.currentGeolocation = locationCoordinates;
                WeatherAPI.getWeatherData(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage);
            } else {
                console.log("# No active location set, starting location fix");
                positionSource.start()
            }
        }

        // change location
        onChangeLocation: {
            // reset weather background image and dashboard
            backgroundImage.showLocalImage("asset:///images/ambient_weather_intro.jpg");
            weatherDashboard.resetDashboard();

            // create geolocation object and fill it with location data
            var locationCoordinates = new GeolocationData.GeolocationData;
            locationCoordinates.latitude = locationData.lat;
            locationCoordinates.longitude = locationData.lon;

            // set location data and load weather data
            ambientWeatherMainPage.currentGeolocation = locationCoordinates;
            WeatherAPI.getWeatherData(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage);
        }

        // image data loaded from flickr
        onImageDataLoaded: {
            // check if images exist for location
            if (imageDataArray.length > 0) {
                console.log("# Found " + imageDataArray.length + " images for location " + ambientWeatherMainPage.currentGeolocation.latitude + " / " + ambientWeatherMainPage.currentGeolocation.longitude);

                // fill global image array with data
                backgroundImage.imageDataArray = imageDataArray;

                // reset search radius (this may have been changed)
                ambientWeatherMainPage.currentLocationSearchRadius = Globals.locationSearchRadius;
            } else {
                console.log("# No images found for location " + ambientWeatherMainPage.currentGeolocation.latitude + " / " + ambientWeatherMainPage.currentGeolocation.longitude);

                // extend search radius and search again
                ambientWeatherMainPage.currentLocationSearchRadius += Globals.locationSearchRadius;
                FlickrAPI.getFlickrSearchResults(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage.currentWeatherdata, ambientWeatherMainPage.currentLocationSearchRadius, ambientWeatherMainPage);
            }
        }

        // weather data loaded from openweathermap
        onWeatherDataLoaded: {
            // store weather data in page component
            ambientWeatherMainPage.currentWeatherdata = weatherData;

            // load weather data into component
            weatherDashboard.setWeatherData(weatherData);

            // load images for location
            FlickrAPI.getFlickrSearchResults(ambientWeatherMainPage.currentGeolocation, weatherData, ambientWeatherMainPage.currentLocationSearchRadius, ambientWeatherMainPage);
        }

        // attach components to page
        attachedObjects: [
            PositionSource {
                id: positionSource
                // desired interval between updates in milliseconds
                updateInterval: 10000

                // when position found (changed from null), update the location objects
                onPositionChanged: {
                    // store coordinates
                    ambientWeatherMainPage.currentGeolocation = positionSource.position.coordinate;

                    // check if location was really fixed
                    if (! ambientWeatherMainPage.currentGeolocation) {
                        console.log("# Location could not be fixed");
                        weatherDashboard.weatherCondition = "Could not get your location :(";
                    } else {
                        console.debug("# Location found: " + ambientWeatherMainPage.currentGeolocation.latitude, ambientWeatherMainPage.currentGeolocation.longitude);

                        // stop location service
                        positionSource.stop();

                        // start loading weather data for location
                        weatherDashboard.weatherCondition = "Loading weather data..";
                        WeatherAPI.getWeatherData(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage);
                    }
                }
            },
            OrientationHandler {
                id: orientationHandler
                onOrientationAboutToChange: {
                    if (orientation == UIOrientation.Portrait) {
                        backgroundImage.orientationChanged(DisplayInfo.width, DisplayInfo.height);
                    } else if (orientation == UIOrientation.Landscape) {
                        backgroundImage.orientationChanged(DisplayInfo.height, DisplayInfo.width);
                    }
                }
                onOrientationChanged: {
                    // Any additional changes to be performed after the orientation
                    // change has occured.
                }
            }
        ]
    }

    // attach components to navigation pane
    attachedObjects: [
        ComponentDefinition {
            id: locationManagementComponent
            source: "pages/LocationManagement.qml"
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}