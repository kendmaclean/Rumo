Class {
	#name : 'BgMainPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'toolbar',
		'ganttPresenter',
		'detailsPresenter',
		'selectedItem'
	],
	#classVars : [
		'LastBounds'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'instance creation' }
BgMainPresenter class >> open [
	self new open
]

{ #category : 'actions' }
BgMainPresenter >> addDependency [
	selectedItem ifNil: [ ^self ].
	BgAddDependencyDialog new
		openOn: selectedItem
		onConfirm: [ :dep |
			selectedItem dependencies add: dep.
			BgRepository uniqueInstance updateItem: selectedItem.
			self refresh ]
]

{ #category : 'actions' }
BgMainPresenter >> addItemOfType: aTypeSymbol [
	| item |
	item := BgItem new.
	item type: aTypeSymbol.
	item title: 'New ' , aTypeSymbol.
	item estimate: 1.
	BgRepository uniqueInstance addItem: item.
	self refresh.
	ganttPresenter highlightItem: item
]

{ #category : 'layout' }
BgMainPresenter >> defaultLayout [
	^SpBoxLayout newTopToBottom
		spacing: 0;
		add: toolbar expand: false;
		add: ganttPresenter;
		add: detailsPresenter withConstraints: [ :c | c height: 180 ];
		yourself
]

{ #category : 'actions' }
BgMainPresenter >> deleteSelectedItem [
	selectedItem ifNil: [ ^self ].
	BgRepository uniqueInstance removeItem: selectedItem.
	selectedItem := nil.
	detailsPresenter clearFields.
	toolbar selectionChanged: false.
	self refresh
]

{ #category : 'initialization' }
BgMainPresenter >> initializePresenters [
	toolbar := self instantiate: BgToolbarPresenter.
	ganttPresenter := self instantiate: BgGanttPresenter.
	detailsPresenter := self instantiate: BgDetailsPresenter.
	self wireCallbacks.
	self bindKeyCombination: KeyboardKey delete asKeyCombination
		toAction: [ self deleteSelectedItem ].
	self refresh
]

{ #category : 'initialization' }
BgMainPresenter >> initializeWindow: aWindowPresenter [
	| ext |
	ext := LastBounds ifNil: [ 900 @ 600 ] ifNotNil: [ :b | b extent ].
	aWindowPresenter title: 'GanttTracker'; initialExtent: ext.
	aWindowPresenter whenWillCloseDo: [
		aWindowPresenter adapter ifNotNil: [ :a | LastBounds := a widget bounds ] ]
]

{ #category : 'actions' }
BgMainPresenter >> onItemSelected: aBgItem [
	selectedItem := aBgItem.
	detailsPresenter loadItem: aBgItem.
	toolbar selectionChanged: true
]

{ #category : 'actions' }
BgMainPresenter >> refresh [
	| result |
	result := BgScheduler new scheduleAll: BgRepository uniqueInstance items.
	ganttPresenter loadScheduleResult: result
]

{ #category : 'actions' }
BgMainPresenter >> removeDependency [
	| deps chosen |
	selectedItem ifNil: [ ^self ].
	deps := selectedItem dependencies.
	chosen := UIManager default
		chooseFrom: (deps collect: [ :d | d title ifNil: [ 'untitled' ] ])
		values: (1 to: deps size) asArray
		lines: #()
		title: 'Remove which dependency?'.
	chosen ifNotNil: [ :idx |
		selectedItem removeDependency: (deps at: idx).
		BgRepository uniqueInstance updateItem: selectedItem.
		self refresh ]
]

{ #category : 'actions' }
BgMainPresenter >> showContextMenuFor: aBgItem [
	| choices actions chosen |
	self onItemSelected: aBgItem.
	choices := OrderedCollection new.
	actions := OrderedCollection new.
	choices add: 'Delete'. actions add: [ self deleteSelectedItem ].
	choices add: 'Add Dependency'. actions add: [ self addDependency ].
	aBgItem dependencies isEmpty ifFalse: [
		choices add: 'Remove Dependency...'.
		actions add: [ self removeDependency ] ].
	chosen := UIManager default
		chooseFrom: choices
		values: (1 to: choices size) asArray
		lines: #()
		title: (aBgItem title ifNil: [ 'untitled' ]).
	chosen ifNotNil: [ :idx | (actions at: idx) value ]
]

{ #category : 'private' }
BgMainPresenter >> wireCallbacks [
	toolbar onAddTask: [ self addItemOfType: #task ].
	toolbar onAddBug: [ self addItemOfType: #bug ].
	toolbar onDelete: [ self deleteSelectedItem ].
	toolbar onAddDependency: [ self addDependency ].
	toolbar onShowCurrent: [ ganttPresenter toggleHideDone ].
	ganttPresenter onSelectionChanged: [ :item | self onItemSelected: item ].
	ganttPresenter onContextMenu: [ :item | self showContextMenuFor: item ].
	detailsPresenter onSave: [ self refresh ]
]
