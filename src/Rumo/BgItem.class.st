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

{ #category : 'persistence' }
BgItem class >> fromDictionary: aDictionary [
	| item |
	item := self basicNew.
	item
		pvtId:        (aDictionary at: 'id');
		title:        (aDictionary at: 'title'       ifAbsent: [ '' ]);
		description:  (aDictionary at: 'description' ifAbsent: [ '' ]);
		type:         (aDictionary at: 'type'        ifAbsent: [ 'task' ]) asSymbol;
		status:       (aDictionary at: 'status'      ifAbsent: [ 'open' ]) asSymbol;
		priority:     (aDictionary at: 'priority'    ifAbsent: [ 'medium' ]) asSymbol;
		estimate:     (aDictionary at: 'estimate'    ifAbsent: [ 0 ]);
		pvtCreatedAt: (DateAndTime fromString:
			(aDictionary at: 'createdAt' ifAbsent: [ DateAndTime now printString ]));
		pvtUpdatedAt: (DateAndTime fromString:
			(aDictionary at: 'updatedAt' ifAbsent: [ DateAndTime now printString ])).
	item pvtDependencies:
		((aDictionary at: 'dependencies' ifAbsent: [ #() ]) asOrderedCollection).
	^ item
]

{ #category : 'persistence' }
BgItem >> asDictionary [
	^ Dictionary new
		at: 'id'           put: id;
		at: 'title'        put: (title ifNil: [ '' ]);
		at: 'description'  put: (description ifNil: [ '' ]);
		at: 'type'         put: type asString;
		at: 'status'       put: status asString;
		at: 'priority'     put: priority asString;
		at: 'estimate'     put: (estimate ifNil: [ 0 ]);
		at: 'dependencies' put: (dependencies collect: [ :dep | dep id ]) asArray;
		at: 'createdAt'    put: createdAt printString;
		at: 'updatedAt'    put: updatedAt printString;
		yourself
]

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

{ #category : 'private' }
BgItem >> pvtCreatedAt: aDateAndTime [
	createdAt := aDateAndTime
]

{ #category : 'private' }
BgItem >> pvtDependencies: aCollection [
	dependencies := aCollection
]

{ #category : 'private' }
BgItem >> pvtId: aString [
	id := aString
]

{ #category : 'private' }
BgItem >> pvtUpdatedAt: aDateAndTime [
	updatedAt := aDateAndTime
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
