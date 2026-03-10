Class {
	#name : 'BgItem',
	#superclass : 'Object',
	#instVars : [
		'id',
		'title',
		'description',
		'type',
		'status',
		'priority',
		'estimate',
		'dependencies',
		'createdAt',
		'updatedAt'
	],
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'accessing' }
BgItem >> createdAt [
	^createdAt
]

{ #category : 'accessing' }
BgItem >> dependencies [
	^dependencies
]

{ #category : 'accessing' }
BgItem >> description [
	^description
]

{ #category : 'accessing' }
BgItem >> description: aString [
	description := aString
]

{ #category : 'accessing' }
BgItem >> estimate [
	^estimate
]

{ #category : 'accessing' }
BgItem >> estimate: aNumber [
	estimate := aNumber
]

{ #category : 'accessing' }
BgItem >> id [
	^id
]

{ #category : 'initialization' }
BgItem >> initialize [
	id := UUID new asString.
	createdAt := DateAndTime now.
	updatedAt := createdAt.
	status := #open.
	priority := #medium.
	type := #task.
	dependencies := OrderedCollection new
]

{ #category : 'testing' }
BgItem >> isBug [
	^type = #bug
]

{ #category : 'testing' }
BgItem >> isTask [
	^type = #task
]

{ #category : 'accessing' }
BgItem >> markUpdated [
	updatedAt := DateAndTime now
]

{ #category : 'printing' }
BgItem >> printOn: aStream [
	aStream
		nextPutAll: (title ifNil: [ 'untitled' ]);
		nextPutAll: ' (';
		nextPutAll: type;
		nextPutAll: ', ';
		nextPutAll: status;
		nextPut: $)
]

{ #category : 'accessing' }
BgItem >> priority [
	^priority
]

{ #category : 'accessing' }
BgItem >> priority: aSymbol [
	priority := aSymbol
]

{ #category : 'accessing' }
BgItem >> removeDependency: aBgItem [
	dependencies remove: aBgItem ifAbsent: []
]

{ #category : 'accessing' }
BgItem >> status [
	^status
]

{ #category : 'accessing' }
BgItem >> status: aSymbol [
	status := aSymbol
]

{ #category : 'accessing' }
BgItem >> title [
	^title
]

{ #category : 'accessing' }
BgItem >> title: aString [
	title := aString
]

{ #category : 'accessing' }
BgItem >> type [
	^type
]

{ #category : 'accessing' }
BgItem >> type: aSymbol [
	type := aSymbol
]

{ #category : 'accessing' }
BgItem >> updatedAt [
	^updatedAt
]
