import bb.cascades 1.0

// import url loader workaround
import org.labsquare 1.0

// import timer type as registered in applicationui.cpp
import QtTimer 1.0

Container {
    id: backgroundImageContainer

    // signal to swith to image with new URL
    signal showImage(string imageURL)

    // signal to swith to a local image
    signal showLocalImage(string imageURL)

    // signal that loading process is done
    signal imageLoadingDone(int imageSlot)

    // array containing all found image items
    // for the current geolocation
    property variant imageDataArray

    // the current index of the available images
    property int currentImageIndex: 0

    // index to the currently used image component
    property int currentImageSlot: 1

    layout: DockLayout {
    }

    // image initially not visible
    // will be set true as soon as Flickr data is available
    // visible: false

    // local image slot
    ImageView {
        id: backgroundImageSlot0

        // layout definition
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Top
        preferredWidth: DisplayInfo.width
        preferredHeight: DisplayInfo.height
        visible: false

        // loading indicator
        // signal if loading is complete
        onImageSourceChanged: {
            if (backgroundImageContainer.currentImageSlot == 1) {
                fadeOut.target = backgroundImageSlot1;
            } else {
                fadeOut.target = backgroundImageSlot2;
            }

            fadeIn.target = backgroundImageSlot0;
            fadeOut.play();
            fadeIn.play();
        }
    }

    // first image slot
    WebImageView {
        id: backgroundImageSlot1

        // layout definition
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Top
        preferredWidth: DisplayInfo.width
        preferredHeight: DisplayInfo.height
        visible: false

        // loading indicator
        // signal if loading is complete
        onLoadingChanged: {
            if (loading == 1) {
                backgroundImageContainer.imageLoadingDone(1);
            }
        }
    }

    // second image slot
    WebImageView {
        id: backgroundImageSlot2

        // layout definition
        scalingMethod: ScalingMethod.AspectFill
        verticalAlignment: VerticalAlignment.Top
        preferredWidth: DisplayInfo.width
        preferredHeight: DisplayInfo.height
        visible: false

        // loading indicator
        // signal if loading is complete
        onLoadingChanged: {
            if (loading == 1) {
                backgroundImageContainer.imageLoadingDone(2);
            }
        }
    }
    
    onImageDataArrayChanged: {
        // set first image
        backgroundImageContainer.currentImageIndex = 0;
        var imageData = imageDataArray[backgroundImageContainer.currentImageIndex];
        backgroundImageContainer.showImage("http://farm" + imageData.farm + ".staticflickr.com/" + imageData.server + "/" + imageData.id + "_" + imageData.secret + "_b.jpg");
    }

    onCurrentImageIndexChanged: {
        var imageData = imageDataArray[backgroundImageContainer.currentImageIndex];
        backgroundImageContainer.showImage("http://farm" + imageData.farm + ".staticflickr.com/" + imageData.server + "/" + imageData.id + "_" + imageData.secret + "_b.jpg");
    }

    // set new image source to slot 0 (always local)
    // this will trigger the loading process, which in turn
    // calls imageLoadingDone with the respective slot
    onShowLocalImage: {
        backgroundImageSlot0.imageSource = imageURL;
    }

    // set new image url to slot that is currently not in use
    // this will trigger the loading process, which in turn
    // calls imageLoadingDone with the respective slot
    onShowImage: {
        imageSwitchTimer.stop();
        if (backgroundImageContainer.currentImageSlot == 1) {
            backgroundImageSlot2.url = imageURL;
        } else {
            backgroundImageSlot1.url = imageURL;
        }
    }

    // loading is done in the new slot
    onImageLoadingDone: {
        backgroundImageContainer.currentImageSlot = imageSlot;
        if (imageSlot == 1) {
            fadeOut.target = backgroundImageSlot2;
            fadeIn.target = backgroundImageSlot1;
        } else {
            fadeOut.target = backgroundImageSlot1;
            fadeIn.target = backgroundImageSlot2;
        }

        fadeOut.play();
        fadeIn.play();
    }

    // attach components to page
    attachedObjects: [
        // timer component
        // used to cycle through images
        Timer {
            id: imageSwitchTimer
            interval: 10000

            // when triggered, load next image
            onTimeout: {
                if ((backgroundImageContainer.imageDataArray != null) && (backgroundImageContainer.imageDataArray.length > 1)) {
                    if ((backgroundImageContainer.currentImageIndex + 1) < (backgroundImageContainer.imageDataArray.length)) {
                        backgroundImageContainer.currentImageIndex += 1;
                    } else {
                        backgroundImageContainer.currentImageIndex = 0;
                    }
                }
            }
        }
    ]

    animations: [
        FadeTransition {
            id: fadeOut
            fromOpacity: 1
            toOpacity: .01
            duration: 1000

            onEnded: {
                target.visible = false;
            }
        },
        FadeTransition {
            id: fadeIn
            fromOpacity: .01
            toOpacity: 1
            duration: 1000

            onStarted: {
                target.visible = true;
            }

            onEnded: {
                console.log("# Image loading done and visible. Starting timer");
                imageSwitchTimer.start();
            }
        }
    ]
}