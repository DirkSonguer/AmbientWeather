// *************************************************** //
// New Location Page
//
// This is a sheet that handles adding a new location.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../classes/locationapi.js" as LocationAPI

Page {
    id: newLocationPage

    // location api signals
    signal locationDataLoaded(variant locationDataArray)
    signal locationDataError(variant errorData)

    titleBar: TitleBar {
        title: "Add new location"
    }

    // actual content
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // container for the location input field
        Container {
            id: locationInputContainer

            // layout definition
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            // layout definition
            topPadding: 15
            rightPadding: 5
            leftPadding: 10
            bottomPadding: 10

            // location input field
            TextField {
                id: locationInput
                hintText: "Enter location name.."
                clearButtonVisible: true

                // input behaviour and handling
                input {
                    submitKey: SubmitKey.Submit
                    onSubmitted: {
                        if (submitter.text.length > 0) {
                            // console.log("# Searching location: " + submitter.text);
                            searchNoItems.visible = false;
                            LocationAPI.getLocationDataForName(submitter.text, newLocationPage);
                        }
                    }
                }
            }

            // search submit button
            ImageButton {
                defaultImageSource: "asset:///images/icon_search_dimmed.png"
                pressedImageSource: "asset:///images/icon_search.png"
                onClicked: {
                    // send the submit signal to the text input field
                    locationInput.input.submitted(locationInput);
                }
            }
        }

        // divider
        Divider {
        }

        // container for error / info messages
        Container {
            // layout definition
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            // results text
            Label {
                id: searchNoItems

                // set initial visibility to false
                visible: false;

                // content
                text: qsTr("Could not find any location with this name, sorry")
                textStyle.base: SystemDefaults.TextStyles.BigText
                multiline: true
            }
        }

        // location list component
        LocationList {
            id: locationList

            onLocationClicked: {
                locationManagementPage.addNewLocation(locationData);
                newLocationSheet.close();
            }
        }
    }

    onLocationDataLoaded: {
        locationList.clearList();
        for (var index in locationDataArray) {
            locationList.addToList(locationDataArray[index]);
        }

        if (locationDataArray.length < 1) {
            searchNoItems.visible = true;
        }
    }

    onLocationDataError: {
        searchNoItems.visible = true;
    }

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icon_close.png"

            // close sheet when pressed
            // note that the about sheet is defined in the main.qml
            onTriggered: {
                newLocationSheet.close();
            }
        }
    ]
}
