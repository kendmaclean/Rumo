Class {
	#name : 'BgScheduleResult',
	#superclass : 'Object',
	#instVars : [
		'scheduledItems',
		'computedAt',
		'anchorDate'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'accessing' }
BgScheduleResult >> anchorDate [
	^anchorDate
]

{ #category : 'accessing' }
BgScheduleResult >> anchorDate: aDate [
	anchorDate := aDate
]

{ #category : 'accessing' }
BgScheduleResult >> computedAt [
	^computedAt
]

{ #category : 'accessing' }
BgScheduleResult >> computedAt: aDateAndTime [
	computedAt := aDateAndTime
]

{ #category : 'accessing' }
BgScheduleResult >> scheduledItems [
	^scheduledItems
]

{ #category : 'accessing' }
BgScheduleResult >> scheduledItems: aCollection [
	scheduledItems := aCollection
]
