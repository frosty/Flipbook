# Flipbook

A Swift tool for rendering UIViews to image sequences for use with WatchKit, and an accompanying sample WatchKit project.

## Usage

Firstly, drag `Flipbook.swift` into your project.

There are two ways to use Flipbook.

1. Create a new Flipbook, and simply attach it to a target view. You must provide a duration (how long to capture snapshots for), and an image prefix (used to name snapshot pngs):

	```swift
	activityFlipbook = Flipbook()
	activityFlipbook.renderTargetView(activity, duration: 1.0, imagePrefix: "activity")
	activity.startAnimating()
	```

2. Create a new Flipbook, provide a target view, and update its appearance for each frame:

	```swift
    arcFlipbook = Flipbook()
        
    arcFlipbook.renderTargetView(arcView, imagePrefix: "arc", frameCount: 60) { (view, frame) in
        if let arcView = view as? ArcView {
            arcView.shapeLayer.strokeEnd = CGFloat(frame) * (1.0 / 60.0)
        }
    }
    ```

The `frame` parameter provided by the update block will be an integer from 0 to `frameCount`.

## Where are my images?

Once you've run your app and captured your frames, the debug console will contain the path where your images are saved. It's much easier to record using the iOS simulator, as the path is easily accessible. 
	
```bash
[Flipbook] Starting capture...
[Flipbook] Images exported to: /Users/frosty/Library/Developer/CoreSimulator/Devices/2CC4876B-9C2F-4653-A7F4-5EFA5A038BEA/data/Containers/Data/Application/62499F6C-87C7-4C88-9300-5E113862C447/Documents
[Flipbook] Capture complete!
```

Open up the directory in Finder or the console, and you'll see all the images.

## Animating images in WatchKit

The provided project also includes a sample WatchKit App, which animates some demo images. Animating images is quite straightforward:

1. Drag your image sequence into your WatchKit App.
2. Add a `WKInterfaceImage` to your Storyboard and hook it up to an outlet in your interface controller.
3. Set the image name of the `WKInterfaceImage` to your `imagePrefix` plus a dash:
	
	```swift
    arcImage.setImageNamed("arc-")
    ```

4. Start animating:
    
    ```swift
    arcImage.startAnimatingWithImagesInRange(NSMakeRange(0, 60), duration: 1.0, repeatCount: 0)
    ```
