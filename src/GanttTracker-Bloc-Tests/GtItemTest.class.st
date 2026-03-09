Class {
	#name : 'GtItemTest',
	#superclass : 'TestCase',
	#category : 'GanttTracker-Bloc-Tests',
	#package : 'GanttTracker-Bloc-Tests'
}

{ #category : 'tests' }
GtItemTest >> testDefaultValues [
	| item |
	item := GtItem new.
	self deny: item id isNil.
	self assert: item status equals: #open.
	self assert: item priority equals: #medium.
	self assert: item type equals: #task.
	self assert: item dependencies isEmpty.
	self deny: item createdAt isNil.
	self deny: item updatedAt isNil
]

{ #category : 'tests' }
GtItemTest >> testIsBug [
	| item |
	item := GtItem new.
	item type: #bug.
	self deny: item isTask.
	self assert: item isBug
]

{ #category : 'tests' }
GtItemTest >> testIsTask [
	| item |
	item := GtItem new.
	item type: #task.
	self assert: item isTask.
	self deny: item isBug
]

{ #category : 'tests' }
GtItemTest >> testMarkUpdated [
	| item before |
	item := GtItem new.
	before := item updatedAt.
	(Delay forMilliseconds: 10) wait.
	item markUpdated.
	self deny: item updatedAt identicalTo: before
]

{ #category : 'tests' }
GtItemTest >> testPrintOn [
	| item str |
	item := GtItem new.
	item title: 'My Task'.
	str := item printString.
	self assert: (str includesSubstring: 'My Task')
]
