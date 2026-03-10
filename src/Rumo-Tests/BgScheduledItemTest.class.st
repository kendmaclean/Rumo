Class {
	#name : 'BgScheduledItemTest',
	#superclass : 'TestCase',
	#category : 'Rumo-Tests',
	#package : 'Rumo-Tests'
}

{ #category : 'tests' }
BgScheduledItemTest >> testAccessors [
	| si item |
	si := BgScheduledItem new.
	item := BgItem new.
	si item: item.
	si startDay: 5.
	si endDay: 10.
	self assert: si item identicalTo: item.
	self assert: si startDay equals: 5.
	self assert: si endDay equals: 10
]

{ #category : 'tests' }
BgScheduledItemTest >> testInitialState [
	| si |
	si := BgScheduledItem new.
	self assert: si item isNil.
	self assert: si startDay isNil.
	self assert: si endDay isNil
]
