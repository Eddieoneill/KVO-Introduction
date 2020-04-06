import Cocoa

// KVO - Key-value observing

// KVO is an observer pattern
// NotificationCenter is also an observer pattern

// KVO is a one-to many pattern relationship as opposed to delegation whitch is a one-to-one

// In the delegation pattern
// class ViewController: UIViewController {}
// eg. tableView.detaSource = self

// KVO is an Objective-C runtime API
// Along with KVO being an objective-c runtime some essentials are required
// 1. The object being observed needs to be a class
// 2. The class needs to inherit from NSObject, NSObject is the top abstract class in Objective-C. The class also needs to be marked @objc
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic. dynamic means thta the property is being dynamically dispatched (at runtime the compiler verifies the underlying property)
// In swift types are statically dispatched witch means they are checked at compile time vs Objective-C whitch is dynamically dispatched and checked at runtime

// Static vs dynamic dispatch
// https://medium.com/flawless-app-stories/static-vs-dynamic-dispatch-in-swift-a-decisive-choice-cece1e872d

// Dog class (class being observed) - will have a property to be observed
@objc class Dog: NSObject {
    var name: String
    @objc dynamic var age: Int // age is a observable property
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
}

// Observer class one
class DogWalker {
    let dog: Dog
    var birthdayOvservation: NSKeyValueObservation?
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        // \.age is keyPath syntax for KVO observing
        birthdayOvservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // update UI accordingly if in a ViewController class
            guard let age = change.newValue else { return }
            print("************************************************************")
            print("Hey \(dog.name), happy \(age)th birthday from the dog walker")
            print("walker oldValue is \(change.oldValue ?? 0)")
            print("walker newValue is \(age)")
        })
    }
}

// Observer class two
class DogGroomer {
    let dog: Dog
    var birthdayOvservation: NSKeyValueObservation?
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayOvservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            guard let age = change.newValue else { return }
            print("************************************************************")
            print("Hey \(dog.name), happy \(age)th birthday from the dog groomer")
            print("groomer oldValue is \(change.oldValue ?? 0)")
            print("groomer newValue is \(age)")
        })
    }
}

// test out KVO observing on the .age property of Dog
// both classes (DogWalker and DogGroomer should het .age changes)

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy)
//
let dogGroomer = DogGroomer(dog: snoopy)

snoopy.age += 1 // increment from 5 to 6
