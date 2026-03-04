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
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
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
	^customPath ifNil: [
		FileLocator imageDirectory / 'GanttTrackerBloc' / 'items.ston' ]
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
	| path |
	path := self defaultPath.
	items := path exists
		ifTrue: [
			[ path readStreamDo: [ :stream | STON fromStream: stream ] ]
				on: Error do: [ :e | OrderedCollection new ] ]
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
	| path |
	path := self defaultPath.
	path parent ensureCreateDirectory.
	path writeStreamDo: [ :stream |
		STON put: items onStream: stream ]
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
	aBgItem markUpdated.
	self save
]
