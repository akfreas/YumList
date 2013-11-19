WunderTest
==========


WunderTest is the test app I built for the fine folks at 6Wunderkinder!  I hope you guys like it!


Setup
-----------------

I used CocoaPods to install some third-party libraries into the project.  Because the current release of CocoaPods lacks support for some Xcode 5 related features, you may have to run `bundle install` to fetch the latest version.   Just run `pod install` in the main directory after that, and open WunderTest.xcodeworkspace.

Things of note
-------------------

*Includes Unit Test target with 10 tests, mostly related to Core Data coverage
*Several custom, reusable UI components related to common UITableView functionality
*Centralized Core Data functionality, with convenience methods attached to NSManagedObjects using categories
*Standard functionality (reordering, create, delete, etc.)
