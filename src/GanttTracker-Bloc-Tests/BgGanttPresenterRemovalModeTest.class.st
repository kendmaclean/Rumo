Class {
	#name : 'BgGanttPresenterRemovalModeTest',
	#superclass : 'TestCase',
	#instVars : [
		'itemA',
		'itemB',
		'itemC',
		'presenter'
	],
	#category : 'GanttTracker-Bloc-Tests',
	#package : 'GanttTracker-Bloc-Tests'
}

{ #category : 'running' }
BgGanttPresenterRemovalModeTest >> setUp [
	super setUp.
	BgRepository resetAll.
	itemA := BgItem new title: 'A'; estimate: 1; yourself.
	itemB := BgItem new title: 'B'; estimate: 1; yourself.
	itemC := BgItem new title: 'C'; estimate: 1; yourself.
	BgRepository uniqueInstance addItem: itemA.
	BgRepository uniqueInstance addItem: itemB.
	BgRepository uniqueInstance addItem: itemC.
	itemA dependencies add: itemB.
	itemA dependencies add: itemC.
	presenter := BgGanttPresenter new
]

{ #category : 'running' }
BgGanttPresenterRemovalModeTest >> tearDown [
	BgRepository resetAll.
	super tearDown
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testAddModeStillWorks [
	"itemB has no deps — safe to add as dep of itemC"
	presenter enterDependencySelectionModeFor: itemC.
	self assert: presenter isInSelectionMode.
	self assert: (presenter eligibleItems includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testConfirmRemovalFiresCallbackWithSnapshot [
	| received |
	received := nil.
	presenter onDependencyRemovalConfirmed: [ :deps | received := deps ].
	presenter enterDependencyRemovalModeFor: itemA.
	presenter togglePendingRemoval: itemB.
	presenter confirmDependencyRemoval.
	self assert: (received includes: itemB).
	self deny: presenter isInSelectionMode
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testEligibleItemsAreExistingDeps [
	presenter enterDependencyRemovalModeFor: itemA.
	self assert: (presenter eligibleItems includes: itemB).
	self assert: (presenter eligibleItems includes: itemC)
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testEnterRemovalModeSetsMode [
	presenter enterDependencyRemovalModeFor: itemA.
	self assert: presenter isInSelectionMode.
	self assert: presenter selectionSourceItem identicalTo: itemA
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testExitRemovalModeClearsState [
	presenter enterDependencyRemovalModeFor: itemA.
	presenter togglePendingRemoval: itemB.
	presenter exitDependencySelectionMode.
	self deny: presenter isInSelectionMode.
	self assert: presenter pendingRemovals isEmpty
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testNonDepItemsAreIneligibleInRemovalMode [
	| extra |
	extra := BgItem new title: 'D'; estimate: 1; yourself.
	BgRepository uniqueInstance addItem: extra.
	presenter enterDependencyRemovalModeFor: itemA.
	self deny: (presenter eligibleItems includes: extra)
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testTogglePendingRemovalAdds [
	presenter enterDependencyRemovalModeFor: itemA.
	presenter togglePendingRemoval: itemB.
	self assert: (presenter pendingRemovals includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterRemovalModeTest >> testTogglePendingRemovalTwiceRemoves [
	presenter enterDependencyRemovalModeFor: itemA.
	presenter togglePendingRemoval: itemB.
	presenter togglePendingRemoval: itemB.
	self deny: (presenter pendingRemovals includes: itemB)
]
