// *************************************************** //
// Default Cover
//
// The default cover contains the standard active frame
// for the application.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// import url loader workaround
import org.labsquare 1.0

// set import directory for components
import "../components"

SceneCover {
    // signal to set data for the dashboard
    // data is given as type WeatherData
    signal setWeatherData(variant weatherData, variant imageData)

    // reset dashboard data
    signal resetDashboard()

    content: Container {
        layout: DockLayout {
        }

        preferredWidth: 334
        preferredHeight: 396

        // first image slot
        WebImageView {
            id: backgroundImage

            // layout definition
            scalingMethod: ScalingMethod.AspectFill
            verticalAlignment: VerticalAlignment.Top
            // 334 pixels wide by 396
            //            preferredWidth: 334
            //            preferredHeight: 396
            //            visible: true
        }

        Container {
            // layout definition
            background: Color.Black
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Right
            preferredHeight: parent.preferredHeight
            preferredWidth: parent.preferredWidth
            opacity: 0.3
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.BottomToTop
            }

            // layout definition
            verticalAlignment: VerticalAlignment.Bottom
            horizontalAlignment: HorizontalAlignment.Center
            leftPadding: 10
            rightPadding: 10
            topPadding: 10
            bottomPadding: 10

            // the label for the given location data
            Label {
                id: weatherDataLocation

                // layout definition
                horizontalAlignment: HorizontalAlignment.Center
                bottomMargin: 0
                topMargin: 0

                text: "Ambient Weather"

                // text style definition
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.textAlign: TextAlign.Right
                textStyle.color: Color.White
                multiline: true
            }

            // the label for the temperature
            Label {
                id: weatherDataTemperature

                // layout definition
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Bottom
                bottomMargin: 0

                // text style definition
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 30
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Right
                textStyle.color: Color.White
            }
        }
    }

    // set weather data for dashboard
    onSetWeatherData: {
        // console.log("# Setting weather data for cover: " + weatherData.weather_description + " in " + weatherData.name);
        weatherDataTemperature.text = weatherData.main_temp;
        weatherDataLocation.text = weatherData.weather_description + " in " + weatherData.name;

        // show image if available
        if (imageData != undefined) {
            // console.log("# Setting background image for cover: " + imageUrl);
            var imageUrl = "http://farm" + imageData[0].farm + ".staticflickr.com/" + imageData[0].server + "/" + imageData[0].id + "_" + imageData[0].secret + "_z.jpg";
            backgroundImage.url = imageUrl;
        }
    }

    // reset weather data for dashboard
    onResetDashboard: {
        weatherDataLocation.text = "Please wait"
    }
}