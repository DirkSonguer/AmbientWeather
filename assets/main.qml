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

NavigationPane {
    id: navigationPane

    Page {
        id: ambientWeatherMainPage

        // property for the current geolocation
        // contains lat and lon
        property variant currentGeolocation

        // the current index of the available images
        property real currentLocationSearchRadius: Globals.locationSearchRadius

        // flickr api signals
        signal imageDataLoaded(variant imageDataArray)
        signal imageDataError(variant errorData)

        // location api signals
        signal locationDataLoaded(variant locationData)
        signal locationDataError(variant errorData)

        // weather api signals
        signal weatherDataLoaded(variant weatherData)
        signal weatherDataError(variant errorData)

        Container {
            layout: DockLayout {
            }

            BackgroundImage {
                id: backgroundImage
            }

            WeatherDashboard {
                id: weatherDashboard

                bottomPadding: 150
                rightPadding: 20
            }

            // context menu for image gallery
            contextActions: [
                ActionSet {
                    title: "Ambient Weather"
                    subtitle: "Where are you?"

                    ActionItem {
                        title: "Use my current location"
                        imageSource: "asset:///images/icon_changelocation.png"

                        // reload popular media stream on click
                        onTriggered: {
                            console.log("# Getting current location");
                            // stop position query just to make sure it doesn't run anymore
                            positionSource.stop();

                            // reset information labels
                            weatherDashboard.weatherLocation = "Ambient Weather";
                            weatherDashboard.weatherCondition = "Getting your position..";

                            console.log("# Starting location fix");
                            positionSource.start();
                        }
                    }
                    // change current location
                    ActionItem {
                        title: "Choose location manually"
                        imageSource: "asset:///images/icon_managelocation.png"

                        // switch to location list
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

            console.log("# Starting location fix");
            positionSource.start()
        }

        onImageDataLoaded: {
            if (imageDataArray.length > 0) {
                console.log("# Found " + imageDataArray.length + " images for location " + ambientWeatherMainPage.currentGeolocation.latitude + " / " + ambientWeatherMainPage.currentGeolocation.longitude);

                // fill global image array with data
                backgroundImage.imageDataArray = imageDataArray;

                // reset search radius
                ambientWeatherMainPage.currentLocationSearchRadius = Globals.locationSearchRadius;
            } else {
                console.log("# No images found for location " + ambientWeatherMainPage.currentGeolocation.latitude + " / " + ambientWeatherMainPage.currentGeolocation.longitude);

                // extend search radius and search again
                ambientWeatherMainPage.currentLocationSearchRadius += Globals.locationSearchRadius;
                console.log("# Extending search radius to " + ambientWeatherMainPage.currentLocationSearchRadius);
                FlickrAPI.getFlickrSearchResults(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage.currentLocationSearchRadius, ambientWeatherMainPage);
            }
        }

        onLocationDataLoaded: {
        }

        onWeatherDataLoaded: {
            weatherDashboard.setWeatherData(weatherData);
            FlickrAPI.getFlickrSearchResults(ambientWeatherMainPage.currentGeolocation, weatherData, ambientWeatherMainPage.currentLocationSearchRadius, ambientWeatherMainPage);
        }

        // attach components to page
        attachedObjects: [
            PositionSource {
                id: positionSource
                // desired interval between updates in milliseconds
                updateInterval: 10000

                // when position changed, update the location strings
                onPositionChanged: {
                    ambientWeatherMainPage.currentGeolocation = positionSource.position.coordinate;

                    // check if location was really fixed
                    if (! ambientWeatherMainPage.currentGeolocation) {
                        console.log("# Location could not be fixed");
                        weatherDashboard.weatherCondition = "Could not get your location :(";
                    } else {
                        console.debug("# Location found: " + ambientWeatherMainPage.currentGeolocation.latitude, ambientWeatherMainPage.currentGeolocation.longitude);

                        // stop location service
                        positionSource.stop();

                        // start loading data for location
                        // this can be done simultaniously as all rely on the dame location data
                        weatherDashboard.weatherCondition = "Loading weather data..";
                        // LocationAPI.getLocationData(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage);
                        WeatherAPI.getWeatherData(ambientWeatherMainPage.currentGeolocation, ambientWeatherMainPage);
                    }
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