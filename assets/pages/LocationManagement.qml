// *************************************************** //
// Location Management Page
//
// This is the page that handles the location management
// and implements the header, list, menus and calling
// the respective functionalities.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../classes/locationmanager.js" as LocationManager

Page {
    id: locationManagementPage

    // new location to add
    signal addNewLocation(variant locationData)

    titleBar: TitleBar {
        title: "Location management"
    }

    Container {
        // new location
        Container {
            // layout definition
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            // layout definition
            leftPadding: 10
            topPadding: 15

            // plus icon
            ImageView {
                imageSource: "asset:///images/icon_additem.png"
            }

            // add new location label
            Label {
                id: itemAddNewLocation
                textStyle.base: SystemDefaults.TextStyles.PrimaryText
                text: "Add new location"
                verticalAlignment: VerticalAlignment.Center
            }

            // handle tap on new location action
            // open new location sheet
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        // create sheet for new location
                        var newLocationPage = newLocationComponent.createObject();
                        newLocationSheet.setContent(newLocationPage);
                        newLocationSheet.open();
                    }
                }
            ]
        }

        // divider for the individual list items
        Divider {
            bottomMargin: 0
        }

        LocationList {
            id: storedLocationList
            
            topMargin: 0
            
            onLocationClicked: {
                console.log("# Setting active item " + locationData.display_name);
                LocationManager.setActiveLocation(locationData);
                ambientWeatherMainPage.changeLocation(locationData);
                navigationPane.pop();
            }
            
            onRemoveLocation: {
                console.log("# Deleting item " + locationData.display_name);
                LocationManager.removeLocation(locationData);
                storedLocationList.clearList();
                var locationDataArray = new Array();
                locationDataArray = LocationManager.getStoredLocations();
                for (var index in locationDataArray) {
                    storedLocationList.addToList(locationDataArray[index]);
                }
            }            
        }

        // long press
        // delete
    }
    
    onCreationCompleted: {
        console.log("# Loading location list");
        storedLocationList.clearList();
        var locationDataArray = new Array();
        locationDataArray = LocationManager.getStoredLocations();
        for (var index in locationDataArray) {
            storedLocationList.addToList(locationDataArray[index]);
        }
    }

    onAddNewLocation: {
        console.log("# Adding new location " + locationData.display_name);
        LocationManager.storeNewLocation(locationData);
        storedLocationList.clearList();
        var locationDataArray = new Array();
        locationDataArray = LocationManager.getStoredLocations();
        for (var index in locationDataArray) {
            storedLocationList.addToList(locationDataArray[index]);
        }
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [
        // sheet for about page
        // this is used by the main menu about item
        Sheet {
            id: newLocationSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: newLocationComponent
                    source: "../sheets/NewLocation.qml"
                }
            ]
        }
    ]
}
