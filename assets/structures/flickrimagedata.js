// *************************************************** //
// Image Data Structure
//
// This structure holds the image data for a single
// Flickr image item.
// Note that names and structure is defined by
// http://ycpi.api.flickr.com/services/rest
// *************************************************** //

// data structure for Flickr image
function FlickrImageData() {
	this.id = "";

	// image type
	this.type = "";

	// image title 
	this.title = "";

	// link to the image
	this.secret = "";
	this.server = "";
	this.farm = "";

	// availability of image
	// as this app only uses public access
	// this will always contain public images
	this.ispublic = "";	

	// owner / author information
	this.owner = "";
	this.isfriend = "";
	this.isfamily = "";
}
