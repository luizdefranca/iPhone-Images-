# iPhone-Images-
Learning Outcomes
Understand how to use NSURLSession to download files.
Understand how to download on a background thread and update UI on the main thread.
Introduction
We're going to use an NSURLSession to download an image from the web and display it in a UIImageView.

He're are 5 different images of the new iPhone 7. Pick your favorite color:

Black: http://imgur.com/bktnImE.png
Jet Black: http://imgur.com/zdwdenZ.png
Gold: http://imgur.com/CoQ8aNl.png
Silver: http://imgur.com/2vQtZBb.png
Rose Gold: http://imgur.com/y9MIaCS.png
Setup
Create a new single view application and add the following code to your view controller's viewDidLoad, using one of the iPhone image URLs:
</br>
<code>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSURL *url = [NSURL URLWithString:@"http://i.imgur.com/bktnImE.png"]; // 1

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3

    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }]; // 4

    [downloadTask resume]; // 5

}
</code>

</br>
Create a new NSURL object from the iPhone image url string.
An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object. The default system values are good for now, so we'll just grab the default configuration.
Create an NSURLSession object using our session configuration. Any changes we want to make to our configuration object must be done before this.
We create a task that will actually download the image from the server. The session creates and configures the task and the task makes the request. Download tasks retrieve data in the form of a file, and support background downloads and uploads while the app is not running. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
A task is created in a suspended state, so we need to resume it. We can also You can also suspend, resume and cancel tasks whenever we want.
Note: As of iOS 9, you need to add a key in your Info.plist file to allow loading of HTTP requests. We need to do this because our image URLs use HTTP instead of HTTPS. Open your Info.plist as Source Code and copy add this key:

This will allow less secure connections to any server that isn't using HTTPS.

Now we can run the app, and the image should download, but we're not doing anything with it yet. Let's change that.

Display the Image
Add a UIImageView to your view controller and call it iPhoneImageView. Make sure that it is constrained to all the edges of your view controller so that it takes up the entire screen.

Now inside your completion handler, add the following code:
<code>
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    if (error) { // 1
        // Handle the error
        NSLog(@"error: %@", error.localizedDescription);
        return;
    }

    NSData *data = [NSData dataWithContentsOfURL:location]; 
    UIImage *image = [UIImage imageWithData:data]; // 2

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // This will run on the main queue

        self.iPhoneImageView.image = image; // 4
    }];

}];
</code>
</br>
The completion handler takes 3 parameters:

location: The location of a file we just downloaded on the device.
response: Response metadata such as HTTP headers and status codes.
error: An NSError that indicates why the request failed, or nil when the request is successful.
If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
The download task downloads the file to the iPhone then lets us know the location of the download using a local URL. In order to access this as a UIImage object, we need to first convert the file's binary into an NSData object, then create a UIImage from that data.
The only thing left to do is display the image on the screen. This is almost as simple as self.iPhoneImageView.image = image; however the networking happens on a background thread and the UI can only be updated on the main thread. This means that we need to make sure that this line of code runs on the main thread.
Run your app and you should see a big picture of the iPhone that you chose.

Stretch Goals
Randomize your iPhone. Add a button to your view controller. Every time a user taps the button, select a random iPhone URL from the list above and download that image. Once the image has downloaded, display it in the image view.
