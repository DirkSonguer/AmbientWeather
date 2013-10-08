// *************************************************** //
// Default Cover
//
// The default cover contains the standard active frame
// for the application.
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

// set import directory for components
import "../components"

SceneCover {
    // signal to set data for the dashboard
    // data is given as type WeatherData
    signal setWeatherData(variant weatherData)

    // reset dashboard data
    signal resetDashboard()

    content: Container {
        layout: StackLayout {
            orientation: LayoutOrientation.BottomToTop
        }

        // layout definition
        background: Color.Black
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Right
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
            horizontalAlignment: HorizontalAlignment.Center
            bottomMargin: 0
            topMargin: 0
            
            // text style definition
            textStyle.fontSize: FontSize.PointValue
            textStyle.fontSizeValue: 30
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Right
            textStyle.color: Color.White
        }
        
        // main weather icon
        WeatherIcon {
            id: weatherDataIcon
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            bottomMargin: 0
            topMargin: 0
        }    
    }

    // set weather data for dashboard
    onSetWeatherData: {
        weatherDataTemperature.text = Math.round(weatherData.main_temp - 273.15) + "°";
        weatherDataLocation.text = weatherData.name;
        weatherDataIcon.weatherData = weatherData;
    }

    // reset weather data for dashboard
    onResetDashboard: {
        weatherDataTemperature.text = "31";
        weatherDataLocation.text = "Please wait"
    }
}