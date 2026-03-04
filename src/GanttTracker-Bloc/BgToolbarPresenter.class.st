Class {
	#name : 'BgToolbarPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'addTaskButton',
		'addBugButton',
		'deleteButton',
		'addDependencyButton',
		'onAddTask',
		'onAddBug',
		'onDelete',
		'onAddDependency',
		'currentButton',
		'onShowCurrent'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'layout' }
BgToolbarPresenter >> defaultLayout [
	^SpBoxLayout newLeftToRight
		spacing: 4;
		add: addTaskButton expand: false;
		add: addBugButton expand: false;
		add: deleteButton expand: false;
		add: addDependencyButton expand: false;
		add: currentButton expand: false;
		yourself
]

{ #category : 'initialization' }
BgToolbarPresenter >> initializePresenters [
	addTaskButton := self newButton
		label: 'Add Task';
		action: [ onAddTask ifNotNil: [ :cb | cb value ] ];
		yourself.
	addBugButton := self newButton
		label: 'Add Bug';
		action: [ onAddBug ifNotNil: [ :cb | cb value ] ];
		yourself.
	deleteButton := self newButton
		label: 'Delete';
		action: [ onDelete ifNotNil: [ :cb | cb value ] ];
		enabled: false;
		yourself.
	addDependencyButton := self newButton
		label: 'Add Dependency';
		action: [ onAddDependency ifNotNil: [ :cb | cb value ] ];
		enabled: false;
		yourself.
	currentButton := self newButton
		label: 'Current';
		action: [ onShowCurrent ifNotNil: [ :cb | cb value ] ];
		yourself
]

{ #category : 'callbacks' }
BgToolbarPresenter >> onAddBug: aBlock [
	onAddBug := aBlock
]

{ #category : 'callbacks' }
BgToolbarPresenter >> onAddDependency: aBlock [
	onAddDependency := aBlock
]

{ #category : 'callbacks' }
BgToolbarPresenter >> onAddTask: aBlock [
	onAddTask := aBlock
]

{ #category : 'callbacks' }
BgToolbarPresenter >> onDelete: aBlock [
	onDelete := aBlock
]

{ #category : 'callbacks' }
BgToolbarPresenter >> onShowCurrent: aBlock [
	onShowCurrent := aBlock
]

{ #category : 'updating' }
BgToolbarPresenter >> selectionChanged: hasSelection [
	deleteButton enabled: hasSelection.
	addDependencyButton enabled: hasSelection
]
