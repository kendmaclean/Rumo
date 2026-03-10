Class {
	#name : 'BgGanttPresenterManageModeTest',
	#superclass : 'TestCase',
	#instVars : [
		'itemA',
		'itemB',
		'itemC',
		'itemD',
		'presenter'
	],
	#category : 'Rumo-Tests',
	#package : 'Rumo-Tests'
}

{ #category : 'running' }
BgGanttPresenterManageModeTest >> setUp [
	super setUp.
	BgRepository resetAll.
	itemA := BgItem new title: 'A'; estimate: 1; yourself.
	itemB := BgItem new title: 'B'; estimate: 1; yourself.
	itemC := BgItem new title: 'C'; estimate: 1; yourself.
	itemD := BgItem new title: 'D'; estimate: 1; yourself.
	BgRepository uniqueInstance addItem: itemA.
	BgRepository uniqueInstance addItem: itemB.
	BgRepository uniqueInstance addItem: itemC.
	BgRepository uniqueInstance addItem: itemD.
	itemA dependencies add: itemB.
	presenter := BgGanttPresenter new
]

{ #category : 'running' }
BgGanttPresenterManageModeTest >> tearDown [
	BgRepository resetAll.
	super tearDown
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testConfirmFiresCallbackWithBothSets [
	| receivedAdds receivedRemovals |
	receivedAdds := nil.
	receivedRemovals := nil.
	presenter onDependencyManageConfirmed: [ :adds :removals |
		receivedAdds := adds.
		receivedRemovals := removals ].
	presenter enterDependencyManageModeFor: itemA.
	presenter toggleManageItem: itemB.
	presenter toggleManageItem: itemC.
	presenter confirmDependencyManage.
	self assert: (receivedRemovals includes: itemB).
	self assert: (receivedAdds includes: itemC).
	self deny: presenter isInSelectionMode
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testConfirmManageNotRemoval [
	"confirmDependencyManage must be called in manage mode, not confirmDependencyRemoval"
	| manageReceived removeReceived |
	manageReceived := false.
	removeReceived := false.
	presenter onDependencyManageConfirmed: [ :adds :removals | manageReceived := true ].
	presenter onDependencyRemovalConfirmed: [ :deps | removeReceived := true ].
	presenter enterDependencyManageModeFor: itemA.
	presenter confirmDependencyManage.
	self assert: manageReceived.
	self deny: removeReceived
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testCurrentDepsAreNotInEligibleItems [
	presenter enterDependencyManageModeFor: itemA.
	self deny: (presenter eligibleItems includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testEligibleItemsExcludeCurrentDepsAndSource [
	presenter enterDependencyManageModeFor: itemA.
	self deny: (presenter eligibleItems includes: itemA).
	self deny: (presenter eligibleItems includes: itemB).
	self assert: (presenter eligibleItems includes: itemC).
	self assert: (presenter eligibleItems includes: itemD)
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testEnterManageModeSetsModeSymbol [
	presenter enterDependencyManageModeFor: itemA.
	self assert: presenter isInSelectionMode.
	self assert: presenter selectionSourceItem identicalTo: itemA
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testExistingAddAndRemoveModeUnaffected [
	presenter enterDependencySelectionModeFor: itemC.
	self assert: presenter isInSelectionMode.
	presenter exitDependencySelectionMode.
	presenter enterDependencyRemovalModeFor: itemA.
	self assert: presenter isInSelectionMode.
	self assert: (presenter eligibleItems includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testExitClearsBothPendingSets [
	presenter enterDependencyManageModeFor: itemA.
	presenter toggleManageItem: itemB.
	presenter toggleManageItem: itemC.
	presenter exitDependencySelectionMode.
	self deny: presenter isInSelectionMode.
	self assert: presenter pendingRemovals isEmpty.
	self assert: presenter pendingAdds isEmpty
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testToggleManageItemOnCurrentDepAddsToRemovals [
	presenter enterDependencyManageModeFor: itemA.
	presenter toggleManageItem: itemB.
	self assert: (presenter pendingRemovals includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testToggleManageItemOnEligibleAddsToAdds [
	presenter enterDependencyManageModeFor: itemA.
	presenter toggleManageItem: itemC.
	self assert: (presenter pendingAdds includes: itemC)
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testToggleManageItemTwiceOnCurrentDepUntoggles [
	presenter enterDependencyManageModeFor: itemA.
	presenter toggleManageItem: itemB.
	presenter toggleManageItem: itemB.
	self deny: (presenter pendingRemovals includes: itemB)
]

{ #category : 'tests' }
BgGanttPresenterManageModeTest >> testToggleManageItemTwiceOnEligibleUntoggles [
	presenter enterDependencyManageModeFor: itemA.
	presenter toggleManageItem: itemC.
	presenter toggleManageItem: itemC.
	self deny: (presenter pendingAdds includes: itemC)
]
