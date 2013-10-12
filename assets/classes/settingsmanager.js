// *************************************************** //
// Settings Manager Script
//
// This script manages the application settings
// Note that this is highly dependant on the 
// ApplicationSettings structure
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "/structures/applicationsettings.js");

function getSettings() {
	console.log("# Getting application settings");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationsettings(temperaturescale TEXT, dashboardstyle TEXT)');
	});

	var applicationSettings = new Array();

	db.transaction(function(tx) {
		var rs = tx.executeSql("SELECT * FROM applicationsettings");
		applicationSettings = rs.rows.item(0);
	});

	return applicationSettings;
}

function setSettings(applicationSettings) {
	console.log("# Storing application settings: " + applicationSettings.temperaturescale + ", " + applicationSettings.dashboardstyle);

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE applicationsettings');
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationsettings(temperaturescale TEXT, dashboardstyle TEXT)');
	});

	var dataStr = "INSERT INTO applicationsettings VALUES(?, ?)";
	var data = [ applicationSettings.temperaturescale, applicationSettings.dashboardstyle ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}

function resetSettings() {
	console.log("# Resetting application settings");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE applicationsettings');
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationsettings(temperaturescale TEXT, dashboardstyle TEXT)');
	});

	var dataStr = "INSERT INTO applicationsettings VALUES(?, ?)";
	var data = [ "Celsius", "0" ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}
