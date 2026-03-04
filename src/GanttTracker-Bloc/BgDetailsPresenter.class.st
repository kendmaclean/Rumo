Class {
	#name : 'BgDetailsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'titleField',
		'typeDropdown',
		'statusDropdown',
		'priorityDropdown',
		'estimateField',
		'descriptionField',
		'depsLabel',
		'saveButton',
		'currentItem',
		'onSave'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'updating' }
BgDetailsPresenter >> clearFields [
	titleField text: ''.
	estimateField text: ''.
	descriptionField text: ''.
	depsLabel label: ''.
	saveButton enabled: false.
	currentItem := nil
]

{ #category : 'layout' }
BgDetailsPresenter >> defaultLayout [
	^SpBoxLayout newTopToBottom
		spacing: 4;
		add: (SpBoxLayout newLeftToRight
			spacing: 8;
			add: (SpBoxLayout newLeftToRight add: (self newLabel label: 'Title:'); add: titleField; yourself);
			add: (SpBoxLayout newLeftToRight add: (self newLabel label: 'Type:'); add: typeDropdown; yourself);
			add: (SpBoxLayout newLeftToRight add: (self newLabel label: 'Status:'); add: statusDropdown; yourself);
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 8;
			add: (SpBoxLayout newLeftToRight add: (self newLabel label: 'Priority:'); add: priorityDropdown; yourself);
			add: (SpBoxLayout newLeftToRight add: (self newLabel label: 'Estimate (days):'); add: estimateField; yourself);
			yourself) expand: false;
		add: (SpBoxLayout newLeftToRight
			spacing: 4;
			add: (self newLabel label: 'Depends on:') expand: false;
			add: depsLabel;
			yourself) expand: false;
		add: descriptionField;
		add: saveButton expand: false;
		yourself
]

{ #category : 'accessing' }
BgDetailsPresenter >> descriptionField [
	^descriptionField
]

{ #category : 'accessing' }
BgDetailsPresenter >> estimateField [
	^estimateField
]

{ #category : 'initialization' }
BgDetailsPresenter >> initializePresenters [
	titleField := self newTextInput.
	typeDropdown := self newDropList.
	statusDropdown := self newDropList.
	priorityDropdown := self newDropList.
	estimateField := self newTextInput.
	descriptionField := self newText.
	depsLabel := self newLabel.
	saveButton := self newButton
		label: 'Save';
		yourself.
	typeDropdown items: #(#task #bug).
	statusDropdown items: #(#open #inProgress #done #blocked).
	priorityDropdown items: #(#low #medium #high #critical).
	saveButton action: [ self saveAction ].
	self clearFields
]

{ #category : 'updating' }
BgDetailsPresenter >> loadItem: aBgItem [
	currentItem := aBgItem.
	titleField text: (aBgItem title ifNil: [ '' ]).
	typeDropdown selectItem: aBgItem type.
	statusDropdown selectItem: aBgItem status.
	priorityDropdown selectItem: aBgItem priority.
	estimateField text: (aBgItem estimate ifNil: [ '' ] ifNotNil: [ :e | e printString ]).
	descriptionField text: (aBgItem description ifNil: [ '' ]).
	depsLabel label: (aBgItem dependencies
		ifEmpty: [ 'none' ]
		ifNotEmpty: [ :deps | ', ' join: (deps collect: [ :d | d title ifNil: [ '?' ] ]) ]).
	saveButton enabled: true
]

{ #category : 'accessing' }
BgDetailsPresenter >> onSave: aBlock [
	onSave := aBlock
]

{ #category : 'actions' }
BgDetailsPresenter >> saveAction [
	currentItem ifNil: [ ^self ].
	currentItem title: titleField text trim.
	currentItem type: typeDropdown selectedItem.
	currentItem status: statusDropdown selectedItem.
	currentItem priority: priorityDropdown selectedItem.
	currentItem estimate: self selectedEstimate.
	currentItem description: descriptionField text.
	BgRepository uniqueInstance updateItem: currentItem.
	onSave ifNotNil: [ :cb | cb value ]
]

{ #category : 'accessing' }
BgDetailsPresenter >> selectedEstimate [
	| text |
	text := estimateField text trim.
	text isEmpty ifTrue: [ ^nil ].
	^[ text asNumber ] on: Error do: [ :e |
		UIManager default inform: 'Estimate must be a number (e.g. 2, 0.5)'.
		^nil ]
]

{ #category : 'accessing' }
BgDetailsPresenter >> titleField [
	^titleField
]
