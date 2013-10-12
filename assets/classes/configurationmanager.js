// *************************************************** //
// Configuration Manager Script
//
// This script manages the application configuration
// Note that this is highly dependant on the 
// ApplicationConfiguration structure
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "/structures/applicationconfiguration.js");

function getConfiguration() {
	console.log("# Getting application configuration");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationconfiguration(temperature TEXT, dashboardstyle TEXT)');
	});

	var applicationConfiguration = new Array();

	db.transaction(function(tx) {
		var rs = tx.executeSql("SELECT * FROM locationdata");
		applicationConfiguration = rs.rows.item(0);
	});

	return applicationConfiguration;
}

function setConfiguration(applicationConfiguration) {
	console.log("# Storing application configuration");

	var db = openDatabaseSync("AmbientWeather", "1.0", "AmbientWeather persistent data storage", 16);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE applicationconfiguration');
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS applicationconfiguration(temperature TEXT, dashboardstyle TEXT)');
	});


	var dataStr = "INSERT INTO applicationconfiguration VALUES(?, ?)";
	var data = [ applicationConfiguration.temperature, applicationConfiguration.dashboardstyle ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
}
