// import blackberry components
import bb.cascades 1.0

Container {
    id: locationList

    // signal to add a new item
    // item is given as type LocationData
    signal addToList(variant locationItem)

    // signal to clear the list contents
    signal clearList()

    // signal if user taps on an item
    // item content (LocationData) will be handed back to the defining page
    signal locationClicked(variant locationData)

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.locationClicked = locationClicked;
    }

    // list view containing the individual location items
    ListView {
        id: locationListView

        // associate the data model for the list view
        dataModel: locationListDataModel

        // define component which will represent the list items in the UI
        listItemComponents: [
            ListItemComponent {
                type: "item"

                // root container containing all the UI elements
                Container {
                    id: locationListItem

                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }

                    // location name
                    Label {
                        textStyle.base: SystemDefaults.TextStyles.PrimaryText
                        text: ListItemData.locationData.display_name
                        multiline: true
                    }

                    gestureHandlers: [
                        // Add a handler for tap gestures
                        TapHandler {
                            onTapped: {
                                Qt.locationClicked(ListItemData.locationData);
                            }
                        }
                    ]

                    // divider for the individual list items
                    Divider {
                    }

                    // tap handling
                    // if item is tapped, change opacity
                    ListItem.onActivationChanged: {
                    }
                }
            }
        ]
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    // the item data is simply added to the data list model
    onAddToList: {
        console.log("# Adding item");
        locationListDataModel.insert({
                "locationData": locationItem
            });
    }

    // signal to clear the gallery contents
    // all items are cleared from the data list model
    onClearList: {
        locationListDataModel.clear();
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: locationListDataModel
            sortedAscending: false

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
