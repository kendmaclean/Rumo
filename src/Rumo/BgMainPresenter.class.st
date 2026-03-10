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
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'instance creation' }
BgMainPresenter class >> open [
	self new open
]

{ #category : 'actions' }
BgMainPresenter >> addDependency [
	self manageDependencies
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
	ganttPresenter exitDependencySelectionMode.
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
	self bindKeyCombination: KeyboardKey escape asKeyCombination
		toAction: [
			ganttPresenter isInSelectionMode
				ifTrue: [ ganttPresenter exitDependencySelectionMode ] ].
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
BgMainPresenter >> manageDependencies [
	selectedItem ifNil: [ ^self ].
	ganttPresenter enterDependencyManageModeFor: selectedItem
]

{ #category : 'actions' }
BgMainPresenter >> onItemSelected: aBgItem [
	selectedItem := aBgItem.
	detailsPresenter loadItem: aBgItem.
	toolbar selectionChanged: true
]

{ #category : 'private' }
BgMainPresenter >> refresh [
	| result |
	result := BgScheduler new scheduleAll: BgRepository uniqueInstance items.
	ganttPresenter loadScheduleResult: result.
	toolbar updateUndoButton: BgRepository uniqueInstance canUndo
]

{ #category : 'actions' }
BgMainPresenter >> removeDependency [
	self manageDependencies
]

{ #category : 'actions' }
BgMainPresenter >> showContextMenuFor: aBgItem [
	| choices actions chosen |
	ganttPresenter isInSelectionMode ifTrue: [ ^self ].
	self onItemSelected: aBgItem.
	choices := OrderedCollection new.
	actions := OrderedCollection new.
	choices add: 'Delete'. actions add: [ self deleteSelectedItem ].
	choices add: 'Manage Dependencies'. actions add: [ self manageDependencies ].
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
	toolbar onUndo: [
		BgRepository uniqueInstance undo.
		self refresh ].
	ganttPresenter onSelectionChanged: [ :item | self onItemSelected: item ].
	ganttPresenter onContextMenu: [ :item | self showContextMenuFor: item ].
	ganttPresenter onDependencySelected: [ :dep |
		selectedItem ifNotNil: [ :src |
			src dependencies add: dep.
			BgRepository uniqueInstance updateItem: src.
			self refresh ] ].
	ganttPresenter onDependencyRemovalConfirmed: [ :removedDeps |
		selectedItem ifNotNil: [ :src |
			removedDeps do: [ :dep | src removeDependency: dep ].
			BgRepository uniqueInstance updateItem: src.
			self refresh ] ].
	ganttPresenter onDependencyManageConfirmed: [ :adds :removals |
		selectedItem ifNotNil: [ :src |
			adds do: [ :dep | src dependencies add: dep ].
			removals do: [ :dep | src removeDependency: dep ].
			BgRepository uniqueInstance updateItem: src.
			self refresh ] ].
	detailsPresenter onSave: [ self refresh ]
]
