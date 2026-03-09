Class {
	#name : 'BgItemTest',
	#superclass : 'TestCase',
	#category : 'GanttTracker-Bloc-Tests',
	#package : 'GanttTracker-Bloc-Tests'
}

{ #category : 'tests' }
BgItemTest >> testAddDependency [
	| item dep |
	item := BgItem new.
	dep := BgItem new.
	self assert: item dependencies isEmpty.
	item dependencies add: dep.
	self assert: item dependencies size equals: 1.
	self assert: item dependencies first identicalTo: dep
]

{ #category : 'tests' }
BgItemTest >> testDefaultValues [
	| item |
	item := BgItem new.
	self deny: item id isNil.
	self assert: item status equals: #open.
	self assert: item priority equals: #medium.
	self assert: item type equals: #task.
	self assert: item dependencies isEmpty.
	self deny: item createdAt isNil.
	self deny: item updatedAt isNil
]

{ #category : 'tests' }
BgItemTest >> testEstimateAccessor [
	| item |
	item := BgItem new.
	self assert: item estimate isNil.
	item estimate: 5.
	self assert: item estimate equals: 5
]

{ #category : 'tests' }
BgItemTest >> testIsBug [
	| item |
	item := BgItem new.
	item type: #bug.
	self deny: item isTask.
	self assert: item isBug
]

{ #category : 'tests' }
BgItemTest >> testIsTask [
	| item |
	item := BgItem new.
	item type: #task.
	self assert: item isTask.
	self deny: item isBug
]

{ #category : 'tests' }
BgItemTest >> testMarkUpdated [
	| item before |
	item := BgItem new.
	before := item updatedAt.
	(Delay forMilliseconds: 10) wait.
	item markUpdated.
	self deny: item updatedAt identicalTo: before
]

{ #category : 'tests' }
BgItemTest >> testPrintOn [
	| item str |
	item := BgItem new.
	item title: 'My Task'.
	str := item printString.
	self assert: (str includesSubstring: 'My Task')
]

{ #category : 'tests' }
BgItemTest >> testRemoveDependency [
	| item dep |
	item := BgItem new.
	dep := BgItem new.
	item dependencies add: dep.
	self assert: item dependencies size equals: 1.
	item removeDependency: dep.
	self assert: item dependencies isEmpty
]
