Class {
	#name : 'BgAddDependencyDialog',
	#superclass : 'SpPresenter',
	#instVars : [
		'itemList',
		'targetItem',
		'validator'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'layout' }
BgAddDependencyDialog >> defaultLayout [
	^SpBoxLayout newTopToBottom
		add: itemList;
		yourself
]

{ #category : 'accessing' }
BgAddDependencyDialog >> eligibleDepsFor: aBgItem [
	| eligible |
	eligible := BgRepository uniqueInstance items select: [ :item |
		item status ~= #done and: [ validator canAdd: item to: aBgItem ] ].
	^ eligible asSortedCollection: [ :a :b | a title asLowercase <= b title asLowercase ]
]

{ #category : 'initialization' }
BgAddDependencyDialog >> initializePresenters [
	validator := BgDependencyValidator new.
	itemList := self newList.
	itemList display: [ :item | item title ifNil: [ 'untitled' ] ]
]

{ #category : 'initialization' }
BgAddDependencyDialog >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Add Dependency';
		initialExtent: 300 @ 300
]

{ #category : 'opening' }
BgAddDependencyDialog >> openOn: aBgItem onConfirm: confirmBlock [
	self targetItem: aBgItem.
	self openDialog
		okAction: [ self selectedDep ifNotNil: confirmBlock ]
]

{ #category : 'accessing' }
BgAddDependencyDialog >> selectedDep [
	^itemList selectedItem
]

{ #category : 'accessing' }
BgAddDependencyDialog >> targetItem: aBgItem [
	targetItem := aBgItem.
	itemList items: (self eligibleDepsFor: aBgItem)
]
