Class {
	#name : 'BgScheduleResultTest',
	#superclass : 'TestCase',
	#category : 'GanttTracker-Bloc-Tests',
	#package : 'GanttTracker-Bloc-Tests'
}

{ #category : 'tests' }
BgScheduleResultTest >> testAccessors [
	| result items |
	result := BgScheduleResult new.
	items := OrderedCollection new.
	result scheduledItems: items.
	result computedAt: DateAndTime now.
	self assert: result scheduledItems identicalTo: items.
	self deny: result computedAt isNil
]

{ #category : 'tests' }
BgScheduleResultTest >> testComputedAtTimestamp [
	| result before after |
	result := BgScheduleResult new.
	before := DateAndTime now.
	(Delay forMilliseconds: 10) wait.
	result computedAt: DateAndTime now.
	(Delay forMilliseconds: 10) wait.
	after := DateAndTime now.
	self assert: result computedAt > before.
	self assert: result computedAt < after
]

{ #category : 'tests' }
BgScheduleResultTest >> testInitialState [
	| result |
	result := BgScheduleResult new.
	self assert: result scheduledItems isNil.
	self assert: result computedAt isNil
]
