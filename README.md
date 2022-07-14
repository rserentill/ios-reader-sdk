![Header](./Documentation/Header.png)



# iOS ReaderSDK

### Version 2.42.0

###### © COPYRIGHT 2001-2022 Zinio. ALL RIGHTS RESERVED.

  - [Description](#description)
  - [Installation](#installation)
    - [Requirements](#requirements)
    - [CocoaPods](#cocoapods)
  - [Usage](#usage)
    - [The Basics](#the-basics)
      - [Initilization](#initilization)
      - [Initial Configuration](#initial-configuration)
      - [Error Handling On Initialization](#error-handling-on-initialization)
    - [ZinioProError](#zinioproerror)
    - [ZinioPro Modules](#ziniopro-modules)
    - [ZinioProReader](#zinioproreader)
      - [Opening Issues](#opening-issues)
      - [Opening Articles](#opening-articles)
      - [Opening Bookmarks](#opening-bookmarks)
    - [ZinioProContent](#zinioprocontent)
      - [Download Issues](#download-issues)
      - [Cancel Downloads](#cancel-downloads)
      - [Retrieve Issue Information](#retrieve-issue-information)
      - [Retrieve Bookmarks Info](#retrieve-bookmarks-info)
      - [Remove Issues](#remove-issues)
      - [Remove Bookmarks](#remove-bookmarks)
      - [Remove All Data](#remove-all-data)
      - [Remove User Data](#remove-user-data)
    - [ZinioProAuth](#zinioproauth)
    - [ZinioProEngine](#zinioproengine)
    - [ZinioProPreferences](#ziniopropreferences)
    - [ZinioProAnalytics](#zinioproanalytics)
    - [ ZinioProMigration](#ziniopromigration)
  - [Troubleshooting](#troubleshooting)

## Description


The iOS **ReaderSDK** is a powerful toolbox which provides users with a full experience to manage and read digital content (magazines, articles, etc). It also lets developers enrich such user experience by provinding a handset of interfaces to communicate with and configure the SDK.

Some use cases ReaderSDK satisfies:

* Open the Zinio Reader. A ready to use UI component fully implemented to provide the user with a great reading experience.
* Manage user's issues
* Get issue information
* Manage user's bookmarks
* Configure Zinio Reader

## Installation

### Requirements 
* Xcode 11.4.1 or later
* Min iOS deployment target 12.0
* Access to private pod repository `ZinioCocoaPods` (to be provided by Zinio)
* Zinio credentials (to be provided by Zinio)

### CocoaPods

As of now, ReaderSDK can only be installed via CocoaPods. Please refer to https://cocoapods.org for further information about managing third party dependencies through CocoaPods.

You will fist need to add Zinio CocoaPods private repo to your CocoaPods installation:

*Note: In order for Zinio to grant you access you will need to provide your SSH public key to Zinio.*

```sh
pod repo add ZinioCocoaPods git@bitbucket.org:ziniollc/ziniococoapods.git
```

Then add the pod to your Podfile:

```ruby
source 'https://cdn.cocoapods.org/'
source 'git@bitbucket.org:ziniollc/ziniococoapods.git'
 
use_frameworks!
 
target 'YOUR_TARGET_NAME' do
  pod 'ReaderSDK'
end
```

If you don't have a Podfile, run `pod init` on terminal inside your project directory to generate it.

Set **ENABLE BITCODE** to **NO**:
It might happen that an error related Bitcode occurs while compiling your project after pod installation. In that case, go to Build Settings in your project and set `Enable Bitcode` to `No`.

## Usage

### The Basics

#### Initilization

`ZinioPro` exposes a singleton once it is initialized. It's important that it has been initialized before using it anywhere in the app, otherwise an exception will be throws, causing a runtime crash.

A good place to do so is during app startup, for example in `AppDelegate`'s `application(_:didFinishLaunchingWithOptions:)` method.

In order to initialize ZinioPro, call `initialize(with:)`, which requires a `ZinioProCredentials` parameter. Provide here your credentials so Zinio can recognize your application and allow its access.

```swift
let credentials = ZinioProCredentials(
  clientId: "YOUR-CLIENT-ID",
  clientSecret: "YOUR-CLIENT-SECRET",
  projectId: 0,
  applicationId: 0,
  environment: .sandbox // Optional, production is the default environment
)

_ = ZinioPro.initialize(with: credentials)
```

##### `ZinioProCredentials` Parameters

* `clientId` - Zinio client id
* `clientSecret` - Zinio client secret
* `projectId` - Zinio project id
* `applicationId` - Zinio application id

*Optional values (overloaded init)*

* `host` - Custom host in case you are not using ZinioPro one
* `environment` -  `.sandbox` or `.production`. Useful for development purposes

#### Initial Configuration

You can also initialize ZinioPro with an optional `ZinioProConfiguration` parameter to setup a specific configuration, for exmample `availableReaderModes` or `enableBookmarks`. To do so, you need to initialize ZinioPro with `initialize(with: configuration:)` method.

The `ZinioProConfiguration` object follows the Builder pattern:

```swift
let configuration = ZinioProConfiguration.build()
  .enableBookmarks(true)
  .availableReaderModes([.pdf, .text])
  .newsstandId(1234)

_ = ZinioPro.initialize(with: credentials, configuration: configuration)
```

##### `ZinioProConfiguration` Options

* `bookmarksEnabled(_:)` - Enable or disable bookmarks feature
* `availableReaderModes(_:)` - The document formats to be available on the reader (options: `.pdf`, `.text`)
* `newsstandId(_:)` - Initial newsstand the SDK will use
* `tintColor(_:)` - Tint color for the reader
* `downloadUsingMobileData(_:)` - Allow or disallow to download content using Mobile data
* `showThumbnailsBar(_:)` - Enable or disable thumbnails bar within the reader while in PDF mode
* `defaultReaderMode(_:)` - The default reading mode when opening an issue for the first time (options: `.pdf`, `.text`)
* `showNotificationWhenIssueIsDownloaded(_:)` - Enable or disable showing a snackbar message when an issue download has completed
* `showTextToSpeech(_:)` - Enable or disable text to speech feature on the reader
* `meteredPaywallLinkText(_:)` - Set the CTA link's text to be displayed on the metered paywall (x out of Y articles left this month) componend inside the reader

#### Error Handling On Initialization

To have control over the initialitzation outcome, you can use `initialize(with: onSuccess: onError:)`:

```swift
ZinioPro.initialize(with: credentials, [configuration: configuration,] onSuccess: {
  // ReaderSDK initialized successfully
}) { error in
  // Handle ZinioProError error here
  error.type
  error.description
  error.extraInfo
}
```

### ZinioProError

* **`description`**: `String` - A description of the error
* **`code`**: `Int` - An error code for the error to be identified
* **`type`**: `ZinioProErrorType` - Enumerable with different type cases
* **`extraInfo`**: `[String: Any]` - Additional information about the error


| Code             | ZinioProErrorType              |
| ---------------- | ------------------------------ |
| 10               | `invalidCredentials`           |
| 20               | `accessDenied`                 |
| 30               | `missingNewsstand`             |
| 40               | `mobileDataDownloadNotAllowed` |
| 50               | `internalError`                |
| 60               | `contentError`                 |
| 70               | `sdkNotInitialized`            |
| 80               | `configurationError`           |
| HTTP status code | `apiError`                     |
| 408              | `networkError`                 |
| 0                | `unknown`                      |

### ZinioPro Modules

The entry point to ReaderSDK is `ZinioPro` class, which is a singleton providing access to seven main modules through `ZinioProSDK` protocol.

![ZinioPro](./Documentation/ZinioPro.png)

1. `ZinioProReader`: Used to open the Reader by issue, article, bookmarks, ...
2. `ZinioProContent`: Used to manage SDK contents. Download new content, get info from current content, remove and manage content, ...
3. `ZinioProPreferences`: Set SDK preferences: Download using Mobile data, show thumbnails bar in PDF mode, default opening mode, ...
4. `ZinioProAuth`: Manage user session.
5. `ZinioProAnalytics`: Used to track events, actions, etc inside the ReaderSDK. You can add your own trackers to capture and handle those events.
6. `ZinioProEngine`: Manage SDK internal engine.
7. `ZinioProMigration`: Offers the possibility to migrate content structure. Useful for major version releases.

Using `ZinioPro.shared` will allow you to use any of the above modules through `ZinioProSDK`:

```swift
public protocol ZinioProSDK {
  var reader: ZinioProReader { get }
  var content: ZinioProContent { get }
  var preferences: ZinioProPreferences { get }
  var auth: ZinioProAuth { get }
  var analytics: ZinioProAnalytics { get }
  var engine: ZinioProEngine { get }
  var migration: ZinioProMigration { get }
}
```

### ReaderSDK

The main modules are `ZinioProReader` and `ZinioProContent`, which are the ones responsible for displaying the user digital content. Here’s how the communication works:

<img src="./Documentation/ReaderSDK.png" alt="ReaderSDK" style="zoom:15%;" />

Note that all the modules aside from reader and content are left out of the picture, as they act as orchestrators in the background to manage needed configurations.

### ZinioProAuth

In order to identify the SDK with a Zinio user and let the SDK handle authorization when requesting protected resources (issues, articles, etc) use the following methods to save a user to the SDK:

```swift
signIn(with userId:)
signOut()
```

* **`userId`**: Zinio user identifier

Some functions are still available without being logged, for example some Articles (featured articles) are free and open to everybody.

### ZinioProReader

This is the main module of ZinioPro. It allows you to open the reader UI with all its functionalities. It provides several methods to open issues, articles or bookmarks.

#### Opening Issues

To open an issue in the Reader you can use one of the following methods:

```swift
openIssue(fromView: issueId: lastPageCTA: onSuccess: onError:)
openLastIssue(fromView: onSuccess: onError:)
```

The second method will open the last magazine the user has read on the issue it was left.

* **`fromView`**: `UIViewController` - The view controller on which the Reader will be presented
* **`issueId`**: `Int` - Id of the issue
* *(optional)* **`lastPageCTA`**: `((Issue) -> Void)?` - Closure to be executed when user clicks on last page's button
* **`onSuccess`**: `(ArticleAccessType) -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `(Error) -> Void` - Closure to be executed if anything goes wrong

#### Opening Articles

The reader can open a single article without downloading the content for the whole issue. It also lets you specify closures to be executed on different situations (sharing an article, clicking the conversion box button, etc).

You can also enable the **metered paywall** feature to engage users by letting them know how many freemium articles they have left.

To open an isolated article in the Reader, use the following method:

```swift
openArticle(fromView: issueId: articleId: conversionBoxAction: shareAction:) unlockArticleAction: [meteredPaywallAction:] onSuccess: onError:)
```

* **`fromView`**: `UIViewController` - The view controller on which the Reader will be presented
* **`issueId`**: `Int` - Id of the issue which contains the article
* **`articleId`**: `Int` - Id of the article
* **`conversionBoxAction`**: `((ArticleModel) -> Void)?` - Closure executed when button is clicked on ConversionBox. If `nil`, then button won't be shown
* **`shareAction`**: `((ArticleModel) -> Void)?` - Closure executed when share button is clicked. If nil, then button won't be shown
* **`unlockArticleAction`**: `((PreviewArticleModel) -> Void)?` - Closure executed when CTA button is clicked in a preview article's conversion box
* *(optional)* **`meteredPaywallAction`**: `((ArticleModelBasicInformationProtocol, MeteredPaywallStatus) -> Void)?` - Closure to execute when user click on the Metered Paywall link, if `nil` metered paywall won't be shown
* **`onSuccess`**: `(ArticleAccessType) -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `(Error) -> Void` - Closure to be executed if anything goes wrong

#### Opening Bookmarks

The reader can algo open an issue from a bookmarked page (PDF) or article (text). You can do so using the following methods:

```swift
openBookmark(fromView: issueId: page: lastPageCTA: onSuccess: onError:)
openBookmark(fromView: issueId: storyId: lastPageCTA: showLoader: onSuccess: onError:)
```

* **`fromView`**: `UIViewController` - The view controller on which the Reader will be presented
* **`issueId`**: `Int` - Id of the issue which contains the article
* **`page`**: `Int` - Index of the page to be opened (bookmarked page)
* **`storyId`**: `Int` - Id of the article (bookmarked story)
* *(optional)* **`lastPageCTA`**: `((Issue) -> Void)?` - Closure to be executed when user clicks on last page's button
* **`showLoader`**: `Bool` - Boolean indicating if the preloading spinner should be shown
* **`onSuccess`**: `(ArticleAccessType) -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `(Error) -> Void` - Closure to be executed if anything goes wrong


###### Notes:

All this methods will automatically download the content before opening it if it hasn't been previously downloaded.

Remember that you need to set a newsstandId in order to grant the download.

If the content is already downloaded (or after a success download process), the Reader will be automatically opened.

#### Open External Content

ZinioPro also offers the possibility to open the reader and render an external resource within a web view. If you have static content on a website and you want to use ZinioPro reader so the user can consume it directly in your app with the ZinioPro user experience, you will be able to do so with the following method:

```swift
openReader(fromView: url: title: shareAction: onSuccess: onError:)
```

* **`fromView`**: `UIViewController` - The view controller on which the Reader will be presented
* **`url`**: `URL` - The url to be rendered
* **`shareAction`**: `((ArticleModel) -> Void)?` - Closure executed when share button is clicked. If nil, then button won't be shown
* **`onSuccess`**: `(ArticleAccessType) -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `(Error) -> Void` - Closure to be executed if anything goes wrong

### ZinioProContent

This module is responsible for providing the content. It retrieves and persists issues and articles content from Zinio backend service, as well as bookmarks information. It provides several methods to manage content.

#### Download Issues

To download issue information (issue name, publication name, etc) and store it alongside its content into the SDK's local storage, the following methods are provided by the content module:

```swift
downloadIssue(issueId: onSuccess: onError:)
downloadIssue(issueId: priority: onSuccess: onError:)
```

* **`issueId`**: `In`t - Issue identifier
* **`priority`**: `QueuePriority` - Priority in the downloads queue (options: `.first`, `.last`)
* **`onSuccess`**: `(Issue) -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `(Error) -> Void` - Closure to be executed if anything goes wrong

Both methods will first check if the issue is already downloaded and available on the reader's local storage, and if so, will directly return it without making any network request.

If the issue is not available locally, the download will be added to the download queue and wait its turn to be downloaded if `priority` is not defined or set to `last`. If `priority` is set to `first` the download will be immediately started.

#### Cancel Downloads

The content module also allows you to cancel ongoing downloads:

```swift
cancelDownloadIssue(issueId:onSuccess:onError:)
```

* **`issueId`**: `In`t - Issue identifier
* **`onSuccess`**: `() -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `() -> Void` - Closure to be executed if anything goes wrong

This method, aside from cancelling any pending downloads for the specified issue, it will also remove any content previously downloaded associated to that issue, except its bookmarks.

#### Retrieve Issue Information

To retrieve the information of the downloaded issues or pending to download, you can use the following methods:

```swift
getIssueInfo(issueId:) // Issue?
getIssuesInfo() // [Issue]
getLocalIssueCoverUrl(publicationId: issueId:) // URL?
getPendingIssuesIds() // Set<Int>
getDownloadedIssuesIds() // Set<Int>
getAllIssuesIds() // Set<Int>
getIssueProgress(issueId:) // IssueProgress
getIssueSizeInMB(withIssueId issueId:) // Int
```

**Parameters**

* **`publicationId`**: `Int` - Publication identifier
* **`issueId`**: `Int` - Issue identifier

**Returned Models**

**`Issue`**

```swift
class Issue {
  let issueId: Int
	let publicationId: Int
	let legacyIssueId: Int
	let name: String
	let cover: String
	let hasPDF: Bool
	let hasXML: Bool
	let allowPDF: Bool
	let allowXML: Bool
	let directionFlow: IssueDirectionFlow
	var publishDate: Date
	var consumerType: IssueConsumerType
	var consumerId: String
}

enum IssueDirectionFlow {
  case leftToRight, rightToLeft
}

enum IssueConsumerType {
  case user, device, external
}
```

**`IssueProgress`**

```swift
class IssueProgress {
  let status: IssueProgressStatus
  let percentage: Float
}

enum IssueProgressStatus {
  case none, downloading, paused, enqueued, finished, error
}
```

#### Retrieve Bookmarks Info

Similarly, you can also retrieve info from all the bookmarks stored in the SDK. You can retrieve info for all story or page bookmarks or you can filter them by issue or publication:

```swift
getStoryBookmarks() // [StoryBookmark]
getStoryBookmarks(publicationId:) // [StoryBookmark]
getStoryBookmarks(issueId:) // [StoryBookmark]

getPageBookmarks() // [PageBookmark]
getPageBookmarks(publicationId:) // [PageBookmark]
getPageBookmarks(issueId:) // [PageBookmark]
```

**Parameters**

* **`publicationId`**: `Int` - Publication identifier
* **`issueId`**: `Int` - Issue identifier

**Returned Models**

**`StoryBookmark`**

```swift
class StoryBookmark {
  var bookmarkId: String
	let publicationId: Int
	let issueId: Int
	let storyId: Int
	var title: String
	var thumbnail: String?
	let section: String?
	var issueName: String
	var publicationName: String
	var issueCover: String?
	let pageRange: String?
	var modificationDate: Date?
	var publishDate: Date?
	var createdDate: Date
	var consumerType: IssueConsumerType
	var consumerId: String
	var fingerprint: String?
	var status: Int
	var synchronized: Bool
}

enum IssueConsumerType {
  case user, device, external
}
```

**`PageBookmark`**

```swift
class PageBookmark {
  var bookmarkId: String
	let publicationId: Int
	let issueId: Int
	var pageNumber: String
	var index: Int
	var title: String?
	var thumbnail: String?
	let section: String?
	var issueName: String
	var publicationName: String
	var issueCover: String?
	var modificationDate: Date?
	var publishDate: Date?
	var createdDate: Date
	var consumerType: IssueConsumerType
	var consumerId: String
	var fingerprint: String?
	var status: Int
	var synchronized: Bool
}

enum IssueConsumerType {
  case user, device, external
}
```

#### Remove Issues

To remove previously downloaded issues (data and content) from the SDK's local storage, you can use the following methods:

```swift
deleteIssue(issueId: [keepBookmarks:] onSuccess: onError:)
deleteIssues(issuesIds: [keepBookmarks:] onSuccess: onError:)
deleteAllIssues([keepBookmarks:] onSuccess: onError:)
```

* **`issueId`**: `Int` - The identifier of the issue to be removed
* **`issueIds`**: `Int` - Array of identifiers of issues to be removed
* *(optional)* **`keepBookmarks`**: `Bool` - A boolean to indicate if bookmarks should be kept or removed. Default option is `false`
* **`onSuccess`**: `() -> Void` - Closure to be executed after the process successfully finishes
* **`onError`**: `() -> Void` - Closure to be executed if anything goes wrong

#### Remove Bookmarks

The content module also allows you to remove stored issue bookmarks in both text and pdf mode. We refer to text pages as *stories* and to pdf pages as *page*. The following methods are provided:

```swift
deleteStoryBookmark(bookmarkId:)
deleteStoryBookmark(bookmarkIds:)
deletePageBookmark(bookmarkId:)
deletePageBookmark(bookmarkIds:)
```

* **`bookmarkId`**: `String` - Bookmark identifier
* **`bookmarkIds`**: `[String]` - Array of bookmark identifiers

#### Remove All Data

The following method removes all the SDK's local content:

```swift
removeUserData(onSuccess: onError:)
```

#### Remove User Data

The following method removes all the SDK's local content associated to the current user:

```swift
removeUserData(onSuccess: onError:)
```

***Note:*** This method is automatically called when signing the user out by calling `ZinioPro.shared.auth.signOut()`. See `ZinioProAuth` for more information.

### ZinioProEngine

ZinioPro has a downloader engine which is responsible for managing the downloads. It uses download queues to ensure all requested downloads are handled appropriately.

By default, the SDK resumes the downloader engine (taking into account preferences limitations) when it's initialized.

You can either start or stop the downloader engine using the following methods:

```swift
resumeDownloader()
stopDownloader()
```

In addition, you can track a download progress by observing the `ReaderSDKIssueDownloadProgress` notification to the default notification center, as in the following example:

```swift
// SomeViewController.swift

private func addObservers() {
  NotificationCenter.default
    .addObserver(
      self,
      selector: #selector(handleDownloadProgress),
      name: .ReaderSDKIssueDownloadProgress,
      object: nil
    )
}

@objc private func handleDownloadProgress(_ notification: Notification) {
  guard let issueProgress = notification.object as? IssueDownloadProgressNotification else { return }
  
  let issueId = issueProgress.issueId // The id of the issue we're downloading
  let progress = issueProgress.progress // Instance of IssueProgress
  let percentage = progress.percentage // Download progress from 0.0 to 1.0
  let status = progress.status // Status of the download (none, downloading, paused, enqueued, finished, error)
}
```

### ZinioProPreferences

This module lets you retrieve and/or change at runtime the preferences that where set up as the initial ZinioPro configuration. These are the available properties and methds:

```swift
var bookmarksEnabled: Bool { get }
var availableReaderModes: [Int] { get }
var showTextToSpeech: Bool { get }
var meteredPaywallLinkText: String? { get }

var downloadUsingMobileData: Bool { get set }
var showThumbnailsBar: Bool { get set }
var defaultReaderMode: ReaderMode { get set }
var showNotificationWhenIssueIsDownloaded: Bool { get set }
var newsstandId: Int { get set }

allowsReaderMode(_ mode: AvailableReaderMode) // Bool
```

You can refer to **Initial Configuration** section for more detailed information.

### ZinioProAnalytics

ReaderSDK triggers events when specific things happen while the app is running for analytics purposes. You can integrate your own analytics trackers to listen to and handle ReaderSDK events.

We separate events in four types:

* **Event:** Something relevant occurs in the app
* **Screen:** When a new screen shows up (normally the Reader screen)
* **Click:** When the user taps on specific interactive elements within the app
* **Action:** A specific action happened, normally done by the user, like taking a screenshot

To setup your trackers, create a class that conforms to `TrackerProtocol`. For this, your class will need to implement the following methods:

```swift
func track(event: String, parameters: [String: Any]?)

func track(screen: String, parameters: [String: Any]?)
  
func track(click: String, parameters: [String: Any]?)
  
func track(action: String, parameters: [String: Any]?)
```

Here is an example for a custom tracker called FancyTracker:

```swift
class FancyTracker: TrackerProtocol {
  func track(event: String, parameters: [String: Any]?) {
     // Send an event with its parameters to your analytics tool.
     ThirdPartyTracker.sendEvent(event, parameters: parameters)
  }
  
  func track(screen: String, parameters: [String: Any]?) {
    // Send a screen event with its parameters to your analytics tool.
    ThirdPartyTracker.sendEvent(screen, parameters: parameters)
  }
  
  func track(click: String, parameters: [String: Any]?) {
    // Send a click event with its parameters to your analytics tool.
    ThirdPartyTracker.sendEvent(click, parameters: parameters)
  }
  
  func track(action: String, parameters: [String: Any]?) {
    // Send an action event with its parameters to your analytics tool.
    ThirdPartyTracker.sendEvent(action, parameters: parameters)
  }
}
```

Then you just need to add your tracker to `ZinioProAnalytics` module with this method. Make sure to do so after `ZinioPro` has been initialized:

```swift
addAnalyticsTrackers(trackers:)
```

**Example:**

```swift
let tracker = FancyTracker()
ZinioPro.shared.analytics.addAnalyticsTrackers(trackers: [tracker])
```

If you need to set default parameters (parameters to be automatically sent alongside with every event), you can do so using the following method:

```swift
upsertDefaultParameters(_:)
```

**Example:**

```swift
let defaultParameters: [SDKTrackerParameters: Any] = [
  .userId: "some id",
  .deviceType: UIDevice.current.userInterfaceIdiom == .phone ? "iPhone" : "iPad"
]

ZinioPro.shared.analytics.upsertDefaultParameters(defaultParameters)
```

You can have as many trackers as you need, for example one tracker for every analytics tool you use. Just add them to the analytics module and ReaderSDK will invoke its methods when events are triggered.

### ZinioProMigration

This module is available in case any data structure or content in the reader SDK needs to be migration upon new versions. It usually won't be used unless explicitly requested by Zinio.

It contains legacy methods which were needed in past versions:

```swift
migratePublishDateToIssuesAndBookmarks(publishDate: issueId:)
migrateOwnerToIssuesAndBookmarks(consumerType: consumerId: issueId:)
```

You can safely ignore this module for now.

## Troubleshooting

We have a bug which causes a `malloc_error` crash on Debug mode. This bug is originated by RxSwift, a third party library our SDK depends on. This only happens when building the app in Debug mode and after executing some network calls.

## Solution

At the end of your `Podfile`, append these lines:

```ruby
post_install do |installer|
  path = "#{installer.config.project_pods_root}/RxSwift/RxSwift/"
​
  [
    'Subjects/AsyncSubject.swift',
    'Subjects/PublishSubject.swift',
    'Subjects/BehaviorSubject.swift',
    'Subjects/ReplaySubject.swift',
    'Observables/Create.swift',
    'Observables/Sink.swift',
    'Deprecated.swift',
    'ObservableType+Extensions.swift'
  ]
    .map { |name| path + name }
    .each do |filename|
      next unless File.exist?(filename)
​
      content = File.read(filename).gsub('#if DEBUG', '#if FORCE_DEBUG')
      File.open(filename, 'w') { |f| f.puts content }
    end
end
```

Then run:
* `pod install`
* `chmod -R 766 Pods/RxSwift/RxSwift`
* `pod install`


Contact
-------
[ziniomobileBCN@zinio.com](mailto:ziniomobileBCN@zinio.com)

