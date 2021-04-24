# Calculator
***iOS Calculator App with undo/redo functionality& EGP->USD Currency Converter*** <br/>
### Features
- [x] Written in Swift 5 using Xcode 12.1
- [x] Supports iOS 12 and newer
- [x] Does not use any 3rd parties
- [x] Full history undo& redo
- [x] Selective Undo for each operation
- [x] MVP Architected
- [x] Unit Tested (Currency Converter Only)
- [x] Documented Code using Jazzy (Currency Converter Only)
- [x] Test Coverage Report using Slather

<br/>

### Architecture
This app is MVP architected since using MVC leads to massive view controllers which is not acceptable, <br/>
MVVM needs reactive extensions and I won't add dependencies to this project for a reason, <br/>
Although honestly I am not good enough with Combine to use it here. <br/>

### Design Patterns
Delegate Design Pattern: MVP's way of communication between Presenter and ViewController. <br/>
Coordinator Design Pattern: Used to setup Tab Bar Controller and its view controllers on App start. <br/>
Mediator Design Pattern: To notify Currency Converter with new Calculations and vice versa. <br/>
