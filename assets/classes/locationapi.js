// *************************************************** //
// Location API Script
//
// This script is used to load and format the requests
// for Open Mapquest. Results will be handed back to the
// calling page.
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "/classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "/structures/locationdata.js");

function getLocationDataForCoordinates(currentGeolocation, callingPage) {
	// console.log("# Searching for location data for lat: " + currentGeolocation.latitude + " and lon: " + currentGeolocation.longitude);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Analysing location data");

			// prepare return object
			var locationItem = new LocationData();

			// get available data
			locationItem.place_id = jsonObject.place_id;
			locationItem.lat = jsonObject.lat;
			locationItem.lon = jsonObject.lon;
			locationItem.display_name = jsonObject.display_name;
			locationItem.licence = jsonObject.licence;
			locationItem.osm_id = jsonObject.osm_id;
			locationItem.osm_type = jsonObject.osm_type;

			// get optional data if available
			if (jsonObject.address != null) {
				locationItem.address_suburb = jsonObject.address.suburb;
				locationItem.address_city_district = jsonObject.address.city_district;
				locationItem.address_city = jsonObject.address.city;
				locationItem.address_county = jsonObject.address.county;
				locationItem.state_district = jsonObject.address.state_district;
				locationItem.address_state = jsonObject.address.state;
				locationItem.address_postcode = jsonObject.address.postcode;
				locationItem.address_country = jsonObject.address.country;
				locationItem.address_country_code = jsonObject.address.country_code;
			}

			// console.log("# Done loading location data");
			callingPage.locationDataLoaded(locationItem);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.locationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// build URL for API call with relevant parameters
	var url = "http://open.mapquestapi.com/nominatim/v1/reverse";
	url += "?format=json";
	url += "&zoom=6";
	url += "&lat=" + currentGeolocation.latitude;
	url += "&lon=" + currentGeolocation.longitude;
	// console.log("# URL for location data call: " + url);

	req.open("GET", url, true);
	req.send();
}

function getLocationDataForName(currentLocationName, callingPage) {
	// console.log("# Searching for location data for name: " + currentLocationName);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Analysing location data");

			var locationDataArray = new Array();

			// iterate through all user items
			for ( var index in jsonObject) {
				if (jsonObject[index].type == "city") {
					// prepare return object
					var locationItem = new LocationData();

					// get available data
					locationItem.place_id = jsonObject[index].place_id;
					locationItem.lat = jsonObject[index].lat;
					locationItem.lon = jsonObject[index].lon;
					locationItem.display_name = jsonObject[index].display_name;
					locationItem.licence = jsonObject[index].licence;
					locationItem.osm_id = jsonObject[index].osm_id;
					locationItem.osm_type = jsonObject[index].osm_type;

					locationDataArray.push(locationItem);
					// console.log("# Found city: " + locationItem.display_name);
				}
			}

			// console.log("# Done loading location data. Found " + locationDataArray.length + " locations");
			callingPage.locationDataLoaded(locationDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				// callingPage.locationDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// build URL for API call with relevant parameters
	var url = "http://open.mapquestapi.com/nominatim/v1/search.php";
	url += "?format=json";
	url += "&q=" + currentLocationName;
	url += "&limit=10";
	// console.log("# URL for location data call: " + url);

	req.open("GET", url, true);
	req.send();
}
