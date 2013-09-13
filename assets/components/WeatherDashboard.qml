// *************************************************** //
// Weather Data Component
//
// The component will display the respective weather
// data
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

Container {
    id: weatherDataComponent

    signal setWeatherData(variant weatherData)

    property alias weatherLocation: weatherDataLocation.text
    property alias weatherCondition: weatherDataCondition.text

    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    verticalAlignment: VerticalAlignment.Bottom
    horizontalAlignment: HorizontalAlignment.Right

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        horizontalAlignment: HorizontalAlignment.Right
        verticalAlignment: VerticalAlignment.Bottom

        WeatherIcon {
            id: weatherDataIcon

            // layout definition
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Bottom
        }

        // the label for the header
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

    // the label for the current condition
    Label {
        id: weatherDataCondition
        
        // layout definition
        textStyle.base: SystemDefaults.TextStyles.BodyText
        horizontalAlignment: HorizontalAlignment.Right
        textStyle.color: Color.White
        topMargin: 0
        bottomMargin: 0
        
        text: "Getting data for position.."
    }

    // the label for the given location
    Label {
        id: weatherDataLocation

        // layout definition
        horizontalAlignment: HorizontalAlignment.Right
        bottomMargin: 0
        topMargin: 0

        text: "Ambient Weather"

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.BigText
        textStyle.textAlign: TextAlign.Right
        textStyle.color: Color.White
        multiline: true
    }

    onSetWeatherData: {
        weatherDataTemperature.text = Math.round(weatherData.main_temp - 273.15) + "°";
        weatherDataCondition.text = weatherData.weather_description + " in";
        weatherDataLocation.text = weatherData.name;
        weatherDataIcon.weatherData = weatherData;
    }
}
