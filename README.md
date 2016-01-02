![GK](http://www.graphkit.io/GK/GraphKit.png)

# Welcome to GraphKit

GraphKit is a data and algorithm framework built on top of CoreData. It is available for iOS and OS X. A major goal in the design of GraphKit is to allow data to be modeled as one would think. The following README is written to get you started, and is by no means a complete tutorial on all that is possible.

### CocoaPods Support

GraphKit is on CocoaPods under the name [GK](https://cocoapods.org/?q=GK).

### Carthage Support

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate GraphKit into your Xcode project using Carthage, specify it in your Cartfile:

```bash
github "CosmicMind/GraphKit"
```

Run carthage to build the framework and drag the built GraphKit.framework into your Xcode project.

### Table of Contents  

* [Entity](#entity)
* [Bond](#bond)
* [Action](#action)
* [Groups](#groups)
* [Probability](#probability)

### Upcoming

* Example Projects
* Additional Data Structures

<a name="entity"/>
### Entity

Let's begin with creating a simple model object and saving it to the Graph. Model objects are known as Entity Objects, which represent a person, place, or thing. Each Entity has a type property that specifies the collection to which it belongs to. Below is an example of creating a "User" type Entity.

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Eve"
user["age"] = 27

graph.save()
```

<a name="bond"/>
### Bond

A Bond is used to form a relationship between two Entity Objects. Like an Entity, a Bond also has a type property that specifies the collection to which it belongs to. A Bond's relationship structure is like a sentence, in that it has a Subject and Object. Let's look at an example to clarify this concept. Below is an example of two Entity Objects, a User and a Book, that have a relationship that is defined by the User being the Author of the Book. The relationship should read as, "User is Author of Book."

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
user["name"] = "Michael Talbot"

let book: Entity = Entity(type: "Book")
book["title"] = "The Holographic Universe"
book.addGroup("Physics")

let author: Bond = Bond(type: "Author")
author["written"] = "May 6th 1992"
author.subject = user
author.object = book

graph.save()
```

<a name="action"/>
### Action

An Action is used to form a relationship between many Entity Objects. Like an Entity, an Action also has a type property that specifies the collection to which it belongs to. An Action's relationship structure is like a sentence, in that it relates a collection of Subjects to a collection of Objects. Below is an example of a User purchasing many Books. It may be thought of as "User Purchased these Book(s)."

```swift
let graph: Graph = Graph()

let user: Entity = Entity(type: "User")
let books: Array<Entity> = graph.searchForEntity(types: ["Book"])

let purchased: Action = Action(type: "Purchased")
purchased.addSubject(user)

for book in books {
	purchased.addObject(book)
}

graph.save()
```

### Groups

Groups are used to organize Entities, Bonds, and Actions into different collections from their types. This allows multiple types to exist in a single collection. For example, a Photo, Video, and Book Entity type may exist in a single group called Media. Another example may be including the Photo, Video, and Book Entity types in a Favorite group for your users' account. Below is an example of using groups.

```swift
// Adding a group.
let photo: Entity = Entity(type: "Photo")
photo.addGroup("Media")
photo.addGroup("Favorite")
photo.addGroup("Holiday Album")

let video: Entity = Entity(type: "Video")
video.addGroup("Media")

let book: Entity = Entity(type: "Book")
book.addGroup("To Read")

// Searching groups.
let favorites: Array<Entity> = graph.searchForEntity(groups: ["Favorite"])
```

<a name="probability"/>
### Probability

GraphKit comes ready with Probability in mind. Your application may be completely catered to your individual user's habits and usage. To demonstrate this wonderful feature, let's look at an example where your application executes a different block of code based on the likelihood that a user will purchase a Physics book.

```swift
let die: SortedSet<Int> = SortedSet<Int>(elements: 1, 2, 3, 4, 5, 6)
print(die.probabilityOf(3)) // output: 0.166666666666667
```

### Data-Driven Design

As data moves through your application, the state of information may be observed to create a reactive experience. Below is an example of watching when a "User Clicked a Button".

![GK](http://www.graphkit.io/GK/DataDriven.png)

```swift
let graph: Graph = Graph() // set UIViewController delegate as GraphDelegate
graph.delegate = self

graph.watch(action: ["Clicked"])

let user: Entity = Entity(type: "User")
let clicked: Action = Action(type: "Clicked")
let button: Entity = Entity(type: "Button")

clicked.addSubject(user)
clicked.addObject(button)

graph.save()

// delegate method
func graphDidInsertAction(graph: Graph, action: Action) {
    switch(action.type) {
    case "Clicked":
      println(action.subjects.first?.type) // User
      println(action.objects.first?.type) // Button
    case "Swiped":
      // handle swipe
    default:
     break
    }
 }
```

### Faceted Search

To explore the intricate relationships within Graph, the search API is as faceted as it is dimensional. This allows the exploration of your data through any view point.

The below example shows how to access a couple Entity types simultaneously.

![GK](http://www.graphkit.io/GK/FacetedSearch.png)

```swift
let graph: Graph = Graph()

// users
let u1: Entity = Entity(type: "User")
u1["name"] = "Michael Talbot"

let u2: Entity = Entity(type: "User")
u2["name"] = "Dr. Walter Russell"

let u3: Entity = Entity(type: "User")
u3["name"] = "Steven Speilberg"

// media
let b1: Entity = Entity(type: "Book")
b1["title"] = "The Holographic Universe"
b1.addGroup("Physics")

let b2: Entity = Entity(type: "Book")
b2["title"] = "Universal One"
b2.addGroup("Physics")
b2.addGroup("Math")

let v1: Entity = Entity(type: "Video")
v1["title"] = "Jurassic Park"
v1.addGroup("Thriller")
v1.addGroup("Action")

// relationships
let r1: Bond = Bond(type: "Author")
r1["year"] = "1992"
r1.subject = u1
r1.object = b1

let r2: Bond = Bond(type: "Author")
r2["year"] = "1926"
r2.subject = u2
r2.object = b2

let r3: Bond = Bond(type: "Director")
r3["year"] = "1993"
r3.subject = u3
r3.object = v1

graph.save()

let media: SortedSet<Entity> = graph.search(entity: ["Book", "Video"])
print(media.count) // output: 3
```

All search results are SortedSet structures that sort data by the id property of the model object. It is possible to narrow the search result by adding group and property filters. The example below demonstrates this.

```swift
let setA: SortedSet<Entity> = graph.search(entity: ["*"], group: ["Physics"])
print(setA.count) // output: 2
```

The * wildcard value tells Graph to look for Entity objects that have values LIKE the ones passed. In the above search, we are asking Graph to look for all Entity types that are in the group "Physics".

The following example searches Graph by property.

```swift
let setB: SortedSet<Entity> = graph.search(entity: ["Book", "Video"], property: [("title", "Jurassic Park")])
print(setB.count) // output: 1
```

We can optionally include a group filter to the above search.

```swift
let setC: SortedSet<Entity> = graph.search(entity: ["Book", "Video"], group: ["Math"], property: [("title", "Jurassic Park")])
print(setC.count) // output: 0
```

The above example returns 0 Entity objects, since "Jurassic Park" is not in the group "Math".

Since return types are SortedSet structures, it is possible to apply set theory to search results. SortedSet structures support operators as well.

Below are some examples of set operations.

```swift
let setA: SortedSet<Bond> = graph.search(bond: ["Author"])
let setB: SortedSet<Bond> = graph.search(bond: ["Director"])

let setC: SortedSet<Entity> = graph.search(entity: ["Book"], group: ["Physics"])
let setD: SortedSet<Entity> = graph.search(entity: ["Book"], group: ["Math"])

let setE: SortedSet<Entity> = graph.search(entity: ["User"])

// union
print((setA + setB).count) // output: 3
print(setA.union(setB).count) // output: 3

// intersect
print(setC.intersect(setD).count) // output: 1

// subset
print(setD < setC) // true
print(setD.isSubsetOf(setC)) // true

// superset
print(setD > setC) // false
print(setD.isSupersetOf(setC)) // false

// contains
print(setE.contains(setA.first!.subject!)) // true

// probability
print(setE.probabilityOf(setA.first!.subject!, setA.last!.subject!)) // 0.666666666666667
```

We can even apply filter, map, and sort operations to search results. Below are some examples using the data from above.

```swift
// filter
let arrayA: Array<Entity> = setC.filter { (entity: Entity) -> Bool in
	return entity["title"] as? String == "The Holographic Universe"
}
print(arrayA.count) // 1

// map
let arrayB: Array<Bond> = setA.map { (bond: Bond) -> Bond in
	bond["mapped"] = true
	return bond
}
print(arrayB.first!["mapped"] as? Bool) // output: true

// sort
let arrayC: Array<Entity> = setE.sort { (a: Entity, b: Entity) -> Bool in
	return (a["name"] as? String) < (b["name"] as? String)
}
print(arrayC.first!["name"] as? String) // output: "Dr. Walter Russell"
```

### Algorithms & Structures

GraphKit comes packed with some useful data structures to help write wonderful algorithms. The following structures are included: List, Stack, Queue, Deque, RedBlackTree, SortedSet, SortedMultiSet, SortedDictionary, and SortedMultiDictionary.

### License

[AGPL-3.0](http://choosealicense.com/licenses/agpl-3.0/)
