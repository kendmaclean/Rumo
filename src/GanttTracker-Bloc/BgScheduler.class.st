Class {
	#name : 'BgScheduler',
	#superclass : 'Object',
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'private' }
BgScheduler >> priorityValueFor: aBgItem [
	^#(#critical #high #medium #low) indexOf: aBgItem priority ifAbsent: [ 5 ]
]

{ #category : 'scheduling' }
BgScheduler >> scheduleAll: aCollection [
	| schedulable blocked result cursor scheduledItems |
	schedulable := aCollection select: [ :item |
		#(#open #inProgress) includes: item status ].
	blocked := aCollection select: [ :item | item status = #blocked ].
	result := BgScheduleResult new.
	scheduledItems := OrderedCollection new.
	cursor := 0.
	(self topologicalSort: schedulable) do: [ :item |
		| depEnd start end si |
		depEnd := item dependencies inject: 0 into: [ :max :dep |
			| prev |
			prev := scheduledItems detect: [ :s | s item == dep ] ifNone: [ nil ].
			prev ifNil: [ max ] ifNotNil: [ max max: prev endDay ] ].
		start := cursor max: depEnd.
		end := start + (item estimate ifNil: [ 0 ]).
		si := BgScheduledItem new.
		si item: item; startDay: start; endDay: end.
		scheduledItems add: si.
		cursor := end ].
	scheduledItems addAll: (blocked collect: [ :item |
		| si |
		si := BgScheduledItem new.
		si item: item; startDay: 0; endDay: 0.
		si ]).
	result scheduledItems: scheduledItems.
	^result
]

{ #category : 'private' }
BgScheduler >> topologicalSort: schedulableItems [
	| inDegree queue sorted restricted |
	restricted := schedulableItems asIdentitySet.
	inDegree := IdentityDictionary new.
	schedulableItems do: [ :item | inDegree at: item put: 0 ].
	schedulableItems do: [ :item |
		item dependencies do: [ :dep |
			(restricted includes: dep) ifTrue: [
				inDegree at: item put: (inDegree at: item) + 1 ] ] ].
	queue := (schedulableItems select: [ :item | (inDegree at: item) = 0 ])
		asSortedCollection: [ :a :b |
			(self priorityValueFor: a) <= (self priorityValueFor: b) ].
	sorted := OrderedCollection new.
	[ queue isEmpty ] whileFalse: [
		| node |
		node := queue removeFirst.
		sorted add: node.
		schedulableItems do: [ :item |
			(item dependencies includes: node) ifTrue: [
				inDegree at: item put: (inDegree at: item) - 1.
				(inDegree at: item) = 0 ifTrue: [
					queue add: item.
					queue := queue asSortedCollection: [ :a :b |
						(self priorityValueFor: a) <= (self priorityValueFor: b) ] ] ] ] ].
	^sorted
]
