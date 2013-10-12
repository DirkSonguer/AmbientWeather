// *************************************************** //
// Settings Page
//
// The about page contains a number of settings for
// the application.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// shared js files
import "../global/globals.js" as Globals
import "../classes/settingsmanager.js" as SettingsManager
import "../structures/applicationsettings.js" as ApplicationSettings

Page {
    id: settingsPage

    property variant currentApplicationSettings

    Container {
        // layout definition
        layout: DockLayout {
        }

        // actual content
        Container {
            layout: StackLayout {
            }
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Center

            Container {
                // layout definition
                layout: StackLayout {
                }

                // instago headline
                Container {
                    topPadding: 25
                    leftPadding: 15
                    Label {
                        text: qsTr("Temperature Scale")
                        textStyle.base: SystemDefaults.TextStyles.BigText
                    }
                }

                // Create a RadioGroup with three options
                RadioGroup {
                    Option {
                        id: scaleCelsius
                        text: "Celsius"
                        selected: true
                    }
                    Option {
                        id: scaleFahrenheit
                        text: "Fahrenheit"
                    }
                    Option {
                        id: scaleKelvin
                        text: "Kelvin"
                    }
                    onSelectedOptionChanged: {
                        var newApplicationSettings = new ApplicationSettings.ApplicationSettings();
                        newApplicationSettings.temperaturescale = selectedOption.text;
                        newApplicationSettings.dashboardstyle = 0;
                        SettingsManager.setSettings(newApplicationSettings);
                    }
                }
            }
        }

        onCreationCompleted: {
/*
        }
            currentApplicationSettings = new Array();
            currentApplicationSettings = SettingsManager.getSettings();
            if (currentApplicationSettings == undefined) {
                SettingsManager.resetSettings();
                currentApplicationSettings = SettingsManager.getSettings();
            }
*/
            switch (ambientWeatherMainPage.currentApplicationSettings.temperaturescale) {
                case "Celsius":
                    scaleCelsius.selected = true;
                    break;
                case "Fahrenheit":
                    scaleFahrenheit.selected = true;
                    break;
                case "Kelvin":
                    scaleKelvin.selected = true;
                    break;
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
                ambientWeatherMainPage.updateApplicationSettings();
                settingsSheet.close();
            }
        }
    ]
}
