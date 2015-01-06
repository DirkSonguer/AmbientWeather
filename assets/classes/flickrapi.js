// *************************************************** //
// Flickr API Script
//
// This script is used to load and format the requests
// for Flickr. Results will be handed back to the
// calling page.
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "/classes/networkhandler.js");
Qt.include(dirPaths.assetPath + "/structures/flickrimagedata.js");

function getFlickrSearchResults(currentGeolocation, currentWeatherData, currentSearchRadius, callingPage) {
	// console.log("# Searching for Flickr image items for lat: " + currentGeolocation.latitude + " and lon: " + currentGeolocation.longitude + " with search radius " + currentSearchRadius);

	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		// this handles the result for each ready state
		var jsonObject = network.handleHttpResult(req);

		// jsonObject contains either false or the http result as object
		if (jsonObject) {
			// console.log("# Analysing Flickr data");

			// prepare return object
			var imageDataArray = new Array();

			// iterate through all image items
			for ( var index in jsonObject.photos.photo) {
				// get image object and store it into return object
				var imageItem = new FlickrImageData();
				imageItem.id = jsonObject.photos.photo[index].id;
				imageItem.type = jsonObject.photos.photo[index].type;
				imageItem.title = jsonObject.photos.photo[index].title;
				imageItem.secret = jsonObject.photos.photo[index].secret;
				imageItem.server = jsonObject.photos.photo[index].server;
				imageItem.farm = jsonObject.photos.photo[index].farm;
				imageItem.ispublic = jsonObject.photos.photo[index].ispublic;
				imageItem.owner = jsonObject.photos.photo[index].owner;
				imageItem.isfriend = jsonObject.photos.photo[index].isfriend;
				imageItem.isfamily = jsonObject.photos.photo[index].isfamily;
				imageDataArray[index] = imageItem;
				// console.log("# Stored image item with id: " +
				// imageDataArray[index].id);
			}

			// console.log("# Done loading Flickr image data");
			callingPage.imageDataLoaded(imageDataArray);
		} else {
			// either the request is not done yet or an error occured
			// check for both and act accordingly
			// found error will be handed over to the calling page
			if ((network.requestIsFinished) && (network.errorData.errorCode != "")) {
				// console.log("# Error found with code " +
				// network.errorData.errorCode + " and message " +
				// network.errorData.errorMessage);
				callingPage.imageDataError(network.errorData);
				network.clearErrors();
			}
		}
	};

	// build tags from weather description
	var flickrTags = "";
	if (currentWeatherData.weather_description != null) {
		flickrTags = currentWeatherData.weather_description.split(' ').join(',');
		flickrTags += "," + currentWeatherData.sys_daytime;
	}

	// build URL for API call with relevant parameters
	var url = "https://api.flickr.com/services/rest";
	url += "?method=flickr.photos.search";
	url += "&api_key=ade5c803d5c7e7bc2012f2a0785f829c";
	url += "&format=json";
	url += "&nojsoncallback=1";
	url += "&sort=interestingness-desc";
	url += "&group_id=1463451@N25&";
	url += "tags=" + flickrTags + "&";	
	url += "bbox=" + (parseFloat(currentGeolocation.longitude) - parseFloat(currentSearchRadius));
	url += "," + (parseFloat(currentGeolocation.latitude) - parseFloat(currentSearchRadius));
	url += "," + (parseFloat(currentGeolocation.longitude) + parseFloat(currentSearchRadius));
	url += "," + (parseFloat(currentGeolocation.latitude) + parseFloat(currentSearchRadius));
	// weatherData.weather_description
	// console.log("# URL for flickr image call: " + url);

	req.open("GET", url, true);
	req.send();
}
