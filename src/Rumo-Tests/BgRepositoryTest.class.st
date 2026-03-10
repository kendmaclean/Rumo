Class {
	#name : 'BgRepositoryTest',
	#superclass : 'TestCase',
	#category : 'Rumo-Tests',
	#package : 'Rumo-Tests'
}

{ #category : 'running' }
BgRepositoryTest >> setUp [
	super setUp.
	BgRepository resetAll
]

{ #category : 'running' }
BgRepositoryTest >> tearDown [
	BgRepository resetAll.
	super tearDown
]

{ #category : 'tests' }
BgRepositoryTest >> testAddItem [
	| repo item |
	repo := BgRepository uniqueInstance.
	self assert: repo items isEmpty.
	item := BgItem new title: 'Test'; yourself.
	repo addItem: item.
	self assert: repo items size equals: 1.
	self assert: repo items first identicalTo: item
]

{ #category : 'tests' }
BgRepositoryTest >> testCanUndo [
	| repo item |
	repo := BgRepository uniqueInstance.
	self deny: repo canUndo.
	item := BgItem new title: 'Test'; yourself.
	repo addItem: item.
	self assert: repo canUndo
]

{ #category : 'tests' }
BgRepositoryTest >> testJsonRoundTrip [
	| repo item1 item2 path repo2 loaded |
	repo := BgRepository uniqueInstance.
	item1 := BgItem new title: 'Alpha'; type: #task; priority: #high; yourself.
	item2 := BgItem new title: 'Beta'; type: #bug; yourself.
	item2 pvtDependencies: (OrderedCollection with: item1).
	repo addItem: item1.
	repo addItem: item2.

	path := repo defaultPath.
	repo2 := BgRepository new.
	repo2 customPath: path.
	repo2 load.
	loaded := repo2 items.

	self assert: loaded size equals: 2.
	self assert: loaded first title equals: 'Alpha'.
	self assert: loaded first priority equals: #high.
	self assert: loaded last type equals: #bug.
	self assert: loaded last dependencies size equals: 1.
	self assert: loaded last dependencies first id equals: item1 id
]

{ #category : 'tests' }
BgRepositoryTest >> testRemoveItem [
	| repo item |
	repo := BgRepository uniqueInstance.
	item := BgItem new title: 'Test'; yourself.
	repo addItem: item.
	self assert: repo items size equals: 1.
	repo removeItem: item.
	self assert: repo items isEmpty
]

{ #category : 'tests' }
BgRepositoryTest >> testRemoveItemNotFound [
	| repo item |
	repo := BgRepository uniqueInstance.
	item := BgItem new title: 'Test'; yourself.
	repo removeItem: item.
	self assert: repo items isEmpty
]

{ #category : 'tests' }
BgRepositoryTest >> testUndo [
	| repo item |
	repo := BgRepository uniqueInstance.
	item := BgItem new title: 'Test'; yourself.
	repo addItem: item.
	self assert: repo items size equals: 1.
	repo undo.
	self assert: repo items isEmpty
]

{ #category : 'tests' }
BgRepositoryTest >> testUndoStackDepth [
	| repo |
	repo := BgRepository uniqueInstance.
	1 to: 7 do: [ :i |
		repo addItem: (BgItem new title: 'Item ', i asString; yourself) ].
	self assert: repo canUndo.
	5 timesRepeat: [ repo undo ].
	self deny: repo canUndo
]

{ #category : 'tests' }
BgRepositoryTest >> testUniqueInstance [
	| inst1 inst2 |
	inst1 := BgRepository uniqueInstance.
	inst2 := BgRepository uniqueInstance.
	self assert: inst1 identicalTo: inst2
]

{ #category : 'tests' }
BgRepositoryTest >> testUpdateItem [
	| repo item |
	repo := BgRepository uniqueInstance.
	item := BgItem new title: 'Before'; yourself.
	repo addItem: item.
	item title: 'After'.
	repo updateItem: item.
	self assert: repo items first title equals: 'After'
]
