/**
* Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program located at the root of the software package
* in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
*/

public class Tree<Key : Comparable, Value> : RedBlackTree<Key, Value>, Equatable {
	/**
		:name:	description
		:description:	Conforms to the Printable Protocol. Outputs the
		data in the Tree in a readable format.
	*/
	public override var description: String {
		return "Tree" + internalDescription
	}

	/**
		:name:	init
		:description:	Constructor.
	*/
	public override init() {
		super.init(uniqueKeys: true)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		:param:	nodes	(Key, Value?)...	Initiates with a given list of nodes.
	*/
	public convenience init(nodes: (Key, Value?)...) {
		self.init(nodes: nodes)
	}
	
	/**
		:name:	init
		:description:	Constructor.
		:param:	nodes	Array<(Key, Value?)>	Initiates with a given array of nodes.
	*/
	public convenience init(nodes: Array<(Key, Value?)>) {
		self.init()
		insert(nodes)
	}

	/**
		:name:	search
		:description:	Accepts a paramter list of keys and returns a subset
		Tree with the indicated values if
		they exist.
	*/
	public func search(keys: Key...) -> Tree<Key, Value> {
		return search(keys)
	}

	/**
		:name:	search
		:description:	Accepts an array of keys and returns a subset
		Tree with the indicated values if
		they exist.
	*/
	public func search(keys: Array<Key>) -> Tree<Key, Value> {
		var tree: Tree<Key, Value> = Tree<Key, Value>()
		for key: Key in keys {
			subTree(key, node: root, tree: &tree)
		}
		return tree
	}

	/**
		:name:	subTree
		:description:	Traverses the Tree and looking for a key value.
		This is used for internal search.
	*/
	internal func subTree(key: Key, node: RedBlackNode<Key, Value>, inout tree: Tree<Key, Value>) {
		if sentinel !== node {
			if key == node.key {
				tree.insert(key, value: node.value)
			}
			subTree(key, node: node.left, tree: &tree)
			subTree(key, node: node.right, tree: &tree)
		}
	}
}

public func ==<Key : Comparable, Value>(lhs: Tree<Key, Value>, rhs: Tree<Key, Value>) -> Bool {
	if lhs.count != rhs.count {
		return false
	}
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		if lhs[i].key != rhs[i].key {
			return false
		}
	}
	return true
}

public func +<Key : Comparable, Value>(lhs: Tree<Key, Value>, rhs: Tree<Key, Value>) -> Tree<Key, Value> {
	let t: Tree<Key, Value> = Tree<Key, Value>()
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = lhs[i]
		t.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = rhs[i]
		t.insert(n.key, value: n.value)
	}
	return t
}

public func -<Key : Comparable, Value>(lhs: Tree<Key, Value>, rhs: Tree<Key, Value>) -> Tree<Key, Value> {
	let t: Tree<Key, Value> = Tree<Key, Value>()
	for var i: Int = lhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = lhs[i]
		t.insert(n.key, value: n.value)
	}
	for var i: Int = rhs.count - 1; 0 <= i; --i {
		let n: (key: Key, value: Value?) = rhs[i]
		t.removeValueForKey(n.key)
	}
	return t
}
