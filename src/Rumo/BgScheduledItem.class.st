Class {
	#name : 'BgScheduledItem',
	#superclass : 'Object',
	#instVars : [
		'item',
		'startDay',
		'endDay'
	],
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'accessing' }
BgScheduledItem >> endDay [
	^endDay
]

{ #category : 'accessing' }
BgScheduledItem >> endDay: aNumber [
	endDay := aNumber
]

{ #category : 'accessing' }
BgScheduledItem >> item [
	^item
]

{ #category : 'accessing' }
BgScheduledItem >> item: aBgItem [
	item := aBgItem
]

{ #category : 'accessing' }
BgScheduledItem >> startDay [
	^startDay
]

{ #category : 'accessing' }
BgScheduledItem >> startDay: aNumber [
	startDay := aNumber
]
