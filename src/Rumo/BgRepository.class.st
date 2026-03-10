Class {
	#name : 'BgRepository',
	#superclass : 'Object',
	#instVars : [
		'items',
		'customPath',
		'undoStack'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'instance creation' }
BgRepository class >> resetAll [
	| path |
	path := self new defaultPath.
	path exists ifTrue: [ path delete ].
	UniqueInstance := nil
]

{ #category : 'instance creation' }
BgRepository class >> uniqueInstance [
	^UniqueInstance ifNil: [ UniqueInstance := self new load ]
]

{ #category : 'mutations' }
BgRepository >> addItem: aBgItem [
	self pushUndoSnapshot.
	items add: aBgItem.
	self save
]

{ #category : 'accessing' }
BgRepository >> canUndo [
	^ undoStack notEmpty
]

{ #category : 'accessing' }
BgRepository >> customPath: aPath [
	customPath := aPath
]

{ #category : 'accessing' }
BgRepository >> defaultPath [
	^ customPath ifNil: [
		FileLocator imageDirectory / 'Rumo' / 'items.json' ]
]

{ #category : 'initialization' }
BgRepository >> initialize [
	items := OrderedCollection new.
	undoStack := OrderedCollection new
]

{ #category : 'accessing' }
BgRepository >> items [
	^items
]

{ #category : 'persistence' }
BgRepository >> load [
	| path raw allItems idMap |
	path := self defaultPath.
	items := path exists
		ifTrue: [
			[
				raw := NeoJSONReader fromString: path contents.
				raw isArray ifFalse: [ ^ items := OrderedCollection new ].
				allItems := (raw collect: [ :d | BgItem fromDictionary: d ]) asOrderedCollection.
				idMap := Dictionary new.
				allItems do: [ :item | idMap at: item id put: item ].
				allItems do: [ :item |
					item pvtDependencies: ((item dependencies
						collect: [ :depId | idMap at: depId ifAbsent: [ nil ] ])
						reject: [ :dep | dep isNil ]) asOrderedCollection ].
				allItems
			] on: Error do: [ :e | OrderedCollection new ]
		]
		ifFalse: [ OrderedCollection new ]
]

{ #category : 'private' }
BgRepository >> pushUndoSnapshot [
	undoStack addLast: items deepCopy.
	undoStack size > 5 ifTrue: [ undoStack removeFirst ]
]

{ #category : 'mutations' }
BgRepository >> removeItem: aBgItem [
	self pushUndoSnapshot.
	items remove: aBgItem ifAbsent: [].
	self save
]

{ #category : 'persistence' }
BgRepository >> save [
	| path json |
	path := self defaultPath.
	path parent ensureCreateDirectory.
	json := NeoJSONWriter toString: (items collect: [ :each | each asDictionary ]).
	path writeStreamDo: [ :stream | stream nextPutAll: json ]
]

{ #category : 'mutations' }
BgRepository >> snapshotForUndo [
	self pushUndoSnapshot
]

{ #category : 'persistence' }
BgRepository >> undo [
	undoStack isEmpty ifTrue: [ ^ self ].
	items := undoStack removeLast.
	self save
]

{ #category : 'mutations' }
BgRepository >> updateItem: aBgItem [
	self pushUndoSnapshot.
	aBgItem markUpdated.
	self save
]
