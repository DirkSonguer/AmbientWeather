// *************************************************** //
// About Page
//
// The about page contains a description for the
// application.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// shared js files
import "../global/globals.js" as Globals

Page {
    id: aboutPage
    Container {
        // layout definition
        layout: DockLayout {
        }

        ScrollView {
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // actual content
            Container {
                layout: StackLayout {
                }
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
                topPadding: 15
                bottomPadding: 25

                // instago icon
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Center
                    // the actual weather icon
                    ImageView {
                        id: weatherIconImage

                        // default image for icon
                        imageSource: "asset:///images/intro_day.png"
                    }

                    // a preview weather icon
                    // this is only used for startup
                    ImageView {
                        id: weatherIconPreview

                        // default image for icon
                        imageSource: "asset:///images/intro_night.png"
                    }

                }

                // instago headline
                Container {
                    leftPadding: 15
                    Label {
                        text: qsTr("AmbientWeather")
                        textStyle.base: SystemDefaults.TextStyles.BigText
                    }
                }

                Container {
                    leftPadding: 15
                    rightPadding: 15

                    // instago version
                    // this is defined in the globals
                    Label {
                        text: qsTr("Version: " + Globals.currentApplicationVersion)
                        textStyle.base: SystemDefaults.TextStyles.SmallText
                    }
                    
                    // instago main about text
                    // this is defined in the global copytext file
                    Label {
                        text: qsTr(Globals.ambientWeatherDescription)
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        multiline: true
                    }
                }
                
                // instago headline
                Container {
                    topMargin: 30
                    leftPadding: 15
                    Label {
                        text: qsTr("Privacy Policy")
                        textStyle.base: SystemDefaults.TextStyles.BigText
                    }
                }
                
                Container {
                    leftPadding: 15
                    rightPadding: 15
                    
                    // instago main about text
                    // this is defined in the global copytext file
                    Label {
                        text: qsTr(Globals.ambientWeatherPrivacy)
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        multiline: true
                    }
                }
            }
        }
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
                aboutSheet.close();
            }
        }
    ]
}
