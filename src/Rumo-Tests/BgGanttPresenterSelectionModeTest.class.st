Class {
	#name : 'BgGanttPresenterSelectionModeTest',
	#superclass : 'TestCase',
	#instVars : [
		'repo',
		'itemA',
		'itemB',
		'itemC',
		'presenter'
	],
	#category : 'Rumo-Tests',
	#package : 'Rumo-Tests'
}

{ #category : 'running' }
BgGanttPresenterSelectionModeTest >> setUp [
	super setUp.
	BgRepository resetAll.
	repo := BgRepository uniqueInstance.
	itemA := BgItem new title: 'A'; estimate: 1; yourself.
	itemB := BgItem new title: 'B'; estimate: 1; yourself.
	itemC := BgItem new title: 'C'; estimate: 1; yourself.
	repo addItem: itemA.
	repo addItem: itemB.
	repo addItem: itemC.
	presenter := BgGanttPresenter new
]

{ #category : 'running' }
BgGanttPresenterSelectionModeTest >> tearDown [
	BgRepository resetAll.
	super tearDown
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testEligibleItemsExcludeCyclicCandidate [
	itemB dependencies add: itemA.
	presenter enterDependencySelectionModeFor: itemB.
	self deny: (presenter eligibleItems includes: itemA)
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testEligibleItemsExcludeDoneItems [
	itemB status: #done.
	presenter enterDependencySelectionModeFor: itemA.
	self deny: (presenter eligibleItems includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testEligibleItemsExcludeExistingDep [
	itemA dependencies add: itemB.
	presenter enterDependencySelectionModeFor: itemA.
	self deny: (presenter eligibleItems includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testEligibleItemsExcludeSource [
	presenter enterDependencySelectionModeFor: itemA.
	self deny: (presenter eligibleItems includes: itemA)
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testEnterSelectionModeSetsSource [
	presenter enterDependencySelectionModeFor: itemA.
	self assert: presenter isInSelectionMode.
	self assert: presenter selectionSourceItem identicalTo: itemA
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testEnterSelectionModeWhileAlreadyInMode [
	presenter enterDependencySelectionModeFor: itemA.
	presenter enterDependencySelectionModeFor: itemB.
	self assert: presenter isInSelectionMode.
	self assert: presenter selectionSourceItem identicalTo: itemB.
	self deny: (presenter eligibleItems includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testExitSelectionModeClearsState [
	presenter enterDependencySelectionModeFor: itemA.
	presenter exitDependencySelectionMode.
	self deny: presenter isInSelectionMode.
	self assert: presenter selectionSourceItem isNil.
	self assert: presenter eligibleItems isEmpty
]

{ #category : 'tests' }
BgGanttPresenterSelectionModeTest >> testInitiallyNotInSelectionMode [
	self deny: presenter isInSelectionMode
]
