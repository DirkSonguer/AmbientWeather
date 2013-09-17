// *************************************************** //
// Location Manager Script
//
// This script manages the manual location a user can
// define (and use instead of his current location)
// *************************************************** //

//include other scripts used here

function getStoredLocations() {
	console.log("# Getting all stored locations");
}

function storeNewLocation(locationData) {
	console.log("# Storing location " + locationData.display_name);
}

function removeLocation(locationData) {
	console.log("# Removing location " + locationData.display_name);
}

function setActiveLocation(locationData) {
	console.log("# Defining active location " + locationData.display_name);
}
