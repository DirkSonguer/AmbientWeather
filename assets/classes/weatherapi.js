// *************************************************** //
// Location API Script
//
// This script is used to load and format the requests
// for Open Weathermap. Results will be handed back to the
// calling page.
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "/classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "/structures/weatherdata.js");

function getWeatherData(currentGeolocation, callingPage) {
	console.log("# Searching for weather data for lat: " + currentGeolocation.latitude + " and lon: " + currentGeolocation.longitude);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			console.log("# Analysing weather data");

			// prepare return object
			var weatherItem = new WeatherData();

			// general data
			weatherItem.dt = jsonObject.dt;
			weatherItem.id = jsonObject.id;
			weatherItem.name = jsonObject.name;
			weatherItem.cod = jsonObject.cod;
			weatherItem.base = jsonObject.base;
			
			// coordinates
			weatherItem.coord_lon = jsonObject.coord.lon;
			weatherItem.coord_lat = jsonObject.coord.lat;

			// country and large scale environment
			weatherItem.sys_country = jsonObject.sys.country;
			weatherItem.sys_sunrise = jsonObject.sys.sunrise;
			weatherItem.sys_sunset = jsonObject.sys.sunset;

			// daytime mode
	        var currentTimestamp = new Date().getTime() / 1000;
	        if ((currentTimestamp > weatherItem.sys_sunrise) && (currentTimestamp < weatherItem.sys_sunset)) {
	        	weatherItem.sys_daytime = "day";
	        } else {
	        	weatherItem.sys_daytime = "night";
	        }
	        console.log("# Sunrise is " + weatherItem.sys_sunrise + ", sunset is " + weatherItem.sys_sunset + ", current time is " + currentTimestamp + ", switching to mode " + weatherItem.sys_daytime);

			// weather data
			weatherItem.weather_id = jsonObject.weather[0].id;
			weatherItem.weather_main = jsonObject.weather[0].main;
			weatherItem.weather_description = jsonObject.weather[0].description;
			weatherItem.weather_icon = jsonObject.weather[0].icon;

			// temp and environment
			weatherItem.main_temp = jsonObject.main.temp;
			weatherItem.main_pressure = jsonObject.main.pressure;
			weatherItem.main_humidity = jsonObject.main.humidity;
			weatherItem.main_temp_min = jsonObject.main.min;
			weatherItem.main_temp_max = jsonObject.main.max;

			// wind speed and feel
			weatherItem.wind_speed = jsonObject.wind.speed;
			weatherItem.wind_deg = jsonObject.wind.deg;

			// clouds
			weatherItem.clouds_all = jsonObject.clouds.all;			
			
			// console.log("# Done loading media data for search");
			callingPage.weatherDataLoaded(weatherItem);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.weatherDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// build URL for API call with relevant parameters
	var url = "http://api.openweathermap.org/data/2.5/weather";
	url += "?lat=" + currentGeolocation.latitude;
	url += "&lon=" + currentGeolocation.longitude;
	console.log("# URL for weather data call: " + url);

	req.open("GET", url, true);
	req.send();
}
