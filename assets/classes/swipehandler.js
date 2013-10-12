// *************************************************** //
// Swipe Handler Class
//
// This class handles swipes as the Cascades
// SDK does not offer swipe detection in the
// gesture handlers.
// *************************************************** //

// singleton instance of class
var swipeHandler = new SwipeHandler();

// Class function that gets the prototype methods
// This also includes the standard objects available
function SwipeHandler() {
	this.startPositionX = 0;
	this.startPositionY = 0;
	
	this.SWIPELEFT = 1;
	this.SWIPERIGHT = 2;
	this.SWIPEUP = 3;
	this.SWIPEDOWN = 4;
}

SwipeHandler.prototype.startSwipeCapture = function(touchEventData) {
	// console.log("# Starting swipe capture with start position X: " + touchEventData.windowX + " and Y: " + touchEventData.windowY);

	this.startPositionX = touchEventData.windowX;
	this.startPositionY = touchEventData.windowY;
};

SwipeHandler.prototype.analyzeSwipeCapture = function(touchEventData) {
	// console.log("# Analyzing swipe capture with end position X: " + touchEventData.windowX + " and Y: " + touchEventData.windowY);

	// get y distance between the two points as absolute distance
	var yDiff = this.startPositionY - touchEventData.windowY;
	if (yDiff < 0) {
		yDiff = -1 * yDiff;
	}

	// check if the minimum y movement is less than 200
	// basically this is the threshold of allowed vertical movement for a
	// horizontal swipe
	if (yDiff < 200) {
		if ((this.startPositionX - touchEventData.windowX) > 250) {
			return this.SWIPELEFT;
		} else if ((touchEventData.windowX - this.startPositionX) > 250) {
			return this.SWIPERIGHT;
		}
	}
	
	// at this point it can't be a horizontal swipe
	// thus check if it was a vertical swipe
	// get x distance between the two points as absolute distance
	var xDiff = this.startPositionX - touchEventData.windowX;
	if (xDiff < 0) {
		xDiff = -1 * xDiff;
	}

	// check if the minimum y movement is less than 150
	// basically this is the threshold of allowed vertical movement for a
	// horizontal swipe
	if (xDiff < 150) {
		if ((this.startPositionY - touchEventData.windowY) > 250) {
			return this.SWIPEUP;
		} else if ((touchEventData.windowY - this.startPositionY) > 250) {
			return this.SWIPEDOWN;
		}
	}

	return 0;
};
