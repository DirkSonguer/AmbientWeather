// *************************************************** //
// Weather Icon Component
//
// The component will display the respective weather
// icon for a given weather code. It will also do the
// mapping of the weather condition to the respective
// icons
// *************************************************** //

// import blackberry components
import bb.cascades 1.0

Container {
    id: weatherIconComponent

    // property contains the weather data handed over by the provider
    // this has been converted to the weather data structure
    property variant weatherData

    // layout definition
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // add bottom padding to show icon at same height as temperature
    bottomPadding: 20

    // the actual weather icon
    ImageView {
        id: weatherIconImage

        // default image for icon
        imageSource: "asset:///images/800_day.png"
    }

    // a preview weather icon
    // this is only used for startup
    ImageView {
        id: weatherIconPreview

        // default image for icon
        imageSource: "asset:///images/800_night.png"
    }

    // set weather icon according to weather data contents
    onWeatherDataChanged: {
        console.log("# Weather code changed to " + weatherData.weather_id);

        // deactivate preview image
        weatherIconPreview.visible = false;

        // set icon mode: day or night
        var iconMode = "_" + weatherData.sys_daytime;

        // set actual icon according to weather id
        switch (weatherData.weather_id) {
            case 200:
            case 201:
            case 202:
            case 210:
            case 211:
            case 221:
            case 231:
                weatherIconImage.imageSource = "asset:///images/200.png";
                break;

            case 212:
            case 230:
            case 232:
                weatherIconImage.imageSource = "asset:///images/212.png";
                break;

            case 300:
            case 301:
            case 302:
            case 310:
            case 311:
                weatherIconImage.imageSource = "asset:///images/300.png";
                break;

            case 312:
            case 321:
                weatherIconImage.imageSource = "asset:///images/312.png";
                break;

            case 500:
                weatherIconImage.imageSource = "asset:///images/300.png";
                break;

            case 501:
            case 520:
            case 521:
                weatherIconImage.imageSource = "asset:///images/501.png";
                break;

            case 502:
            case 503:
            case 504:
            case 522:
                weatherIconImage.imageSource = "asset:///images/502.png";
                break;

            case 511:
                weatherIconImage.imageSource = "asset:///images/511.png";
                break;

            case 600:
            case 601:
                weatherIconImage.imageSource = "asset:///images/600.png";
                break;

            case 602:
                weatherIconImage.imageSource = "asset:///images/602.png";
                break;

            case 611:
            case 621:
                weatherIconImage.imageSource = "asset:///images/621.png";
                break;

            case 701:
            case 711:
            case 721:
            case 731:
            case 741:
                weatherIconImage.imageSource = "asset:///images/803" + iconMode + ".png";
                break;

            case 800:
                weatherIconImage.imageSource = "asset:///images/800" + iconMode + ".png";
                break;

            case 801:
                weatherIconImage.imageSource = "asset:///images/801" + iconMode + ".png";
                break;

            case 802:
                weatherIconImage.imageSource = "asset:///images/802" + iconMode + ".png";
                break;

            case 803:
                weatherIconImage.imageSource = "asset:///images/803" + iconMode + ".png";
                break;

            case 804:
                weatherIconImage.imageSource = "asset:///images/804.png";
                break;
        }
    }
}
