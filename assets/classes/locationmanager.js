// *************************************************** //
// Location Manager Script
//
// This script manages the manual location a user can
// define (and use instead of his current location)
// *************************************************** //

//include other scripts used here

function getStoredLocations() {
	console.log("# Getting all stored locations");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS locationdata(place_id TEXT, lat TEXT, lon TEXT, display_name TEXT, active TEXT)');
	});

	var locationDataArray = new Array();
	var locationItem = new Array();

	db.transaction(function(tx) {
		var rs = tx.executeSql("SELECT * FROM locationdata");
		if (rs.rows.length > 0) {
			for ( var i = 0; i < rs.rows.length; i++) {
				locationItem = rs.rows.item(i);
				locationDataArray.push(locationItem);
				console.log("# Found location item in db " + locationItem.display_name);
			}
		}
	});

	return locationDataArray;
}

function getActiveLocation() {
	console.log("# Getting active location");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS locationdata(place_id TEXT, lat TEXT, lon TEXT, display_name TEXT, active TEXT)');
	});

	var locationItem = new Array();

	var dataStr = "SELECT * FROM locationdata WHERE active = ?";
	var data = [ "1" ];
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr, data);
		if (rs.rows.length > 0) {
			locationItem = rs.rows.item(0);
			console.log("# Found active location item in db " + locationItem.display_name);
		}
	});

	return locationItem;
}

function storeNewLocation(locationData) {
	console.log("# Storing location " + locationData.display_name);

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS locationdata(place_id TEXT, lat TEXT, lon TEXT, display_name TEXT)');
	});

	var dataStr = "SELECT * FROM locationdata WHERE place_id = ?";
	var data = [ locationData.place_id ];
	var foundLocations = 0;
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr, data);
		if (rs.rows.length > 0) {
			console.log("# Found " + rs.rows.length + " already existing entries with this ID");
			foundLocations = rs.rows.length;
		}
	});

	if (foundLocations > 0) {
		return -1;
	}

	var dataStr = "INSERT INTO locationdata VALUES(?, ?, ?, ?, ?)";
	var data = [ locationData.place_id, locationData.lat, locationData.lon, locationData.display_name, "0" ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}

function removeLocation(locationData) {
	console.log("# Removing location " + locationData.display_name);

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS locationdata(place_id TEXT, lat TEXT, lon TEXT, display_name TEXT)');
	});

	var dataStr = "DELETE FROM locationdata WHERE place_id = ?";
	var data = [ locationData.place_id ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});
}

function removeAllLocations(locationData) {
	console.log("# Removing all locations");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE locationdata');
	});
}

function setActiveLocation(locationData) {
	console.log("# Setting active location " + locationData.display_name);

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS locationdata(place_id TEXT, lat TEXT, lon TEXT, display_name TEXT)');
	});

	var dataStr = "UPDATE locationdata SET active = ?";
	var data = [ "0" ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	var dataStr = "UPDATE locationdata SET active = ? WHERE place_id = ?";
	var data = [ "1", locationData.place_id ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}

function resetActiveLocation() {
	console.log("# Resetting active location");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS locationdata(place_id TEXT, lat TEXT, lon TEXT, display_name TEXT)');
	});

	var dataStr = "UPDATE locationdata SET active = ?";
	var data = [ "0" ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}
