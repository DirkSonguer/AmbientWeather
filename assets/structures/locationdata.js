// *************************************************** //
// Location Data Structure
//
// This structure holds location data for a single
// geolocation item.
// Note that names and structure is defined by
// http://open.mapquestapi.com
// *************************************************** //

// data structure for location item
function LocationData() {
	this.place_id = "";
	this.active = "";
	
	// license information
	this.licence = "";
	this.osm_type = "";
	this.osm_id = "";
	
	// location lat and lon
	this.lat = "";
	this.lon = "";
	
	// this is the display name
	// its an aggregation of the known data
	// it should always be available
	this.display_name = "";
	
	// additional location data
	// data here is optional
	this.address_suburb = "";
	this.address_city_district = "";
	this.address_city = "";
	this.address_county = "";
	this.address_state_district = "";
	this.address_state = "";
	this.address_postcode = "";
	this.address_country = "";
	this.address_country_code = "";
}
