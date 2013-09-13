// *************************************************** //
// Weather Data Structure
//
// This structure holds weather information for a given
// location.
// Note that names and structure is defined by
// http://api.openweathermap.org
// *************************************************** //

// data structure for Open Weather Map media
function WeatherData() {
	// general data
	this.dt = "";
	this.id = "";
	this.name = "";
	this.cod = "";
	this.base = "";

	// coordinates
	this.coord_lon = "";
	this.coord_lat = "";

	// country and large scale environment
	this.sys_country = "";
	this.sys_sunrise = "";
	this.sys_sunset = "";
	this.sys_daytime = "";

	// weather data
	this.weather_id = "";
	this.weather_main = "";
	this.weather_description = "";
	this.weather_icon = "";

	// temp and environment
	this.main_temp = "";
	this.main_pressure = "";
	this.main_humidity = "";
	this.main_temp_min = "";
	this.main_temp_max = "";

	// wind speed and feel
	this.wind_speed = "";
	this.wind_deg = "";

	// clouds
	this.clouds_all = "";
}