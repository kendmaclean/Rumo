Class {
	#name : 'BgScheduler',
	#superclass : 'Object',
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'private' }
BgScheduler >> effectivePriorityMap: items [
	"Each item's effective priority = its own priority promoted by
	 the highest-priority item that (transitively) depends on it."
	| map changed |
	map := IdentityDictionary new.
	items do: [ :item | map at: item put: (self priorityValueFor: item) ].
	[ changed := false.
	  items do: [ :item |
	      item dependencies do: [ :dep |
	          (map includesKey: dep) ifTrue: [
	              | cur new |
	              cur := map at: dep.
	              new := cur min: (map at: item).
	              new < cur ifTrue: [
	                  map at: dep put: new.
	                  changed := true ] ] ] ].
	  changed ] whileTrue.
	^ map
]

{ #category : 'private' }
BgScheduler >> priorityValueFor: aBgItem [
	^#(#critical #high #medium #low) indexOf: aBgItem priority ifAbsent: [ 5 ]
]

{ #category : 'scheduling' }
BgScheduler >> scheduleAll: aCollection [
	| schedulable blocked done result cursor scheduledItems |
	schedulable := aCollection select: [ :item |
		#(#open #inProgress) includes: item status ].
	blocked := aCollection select: [ :item | item status = #blocked ].
	done := aCollection select: [ :item | item status = #done ].
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
		BgScheduledItem new item: item; startDay: 0; endDay: 0; yourself ]).
	scheduledItems addAll: (done collect: [ :item |
		BgScheduledItem new item: item; startDay: 0; endDay: 0; yourself ]).
	result scheduledItems: scheduledItems.
	result anchorDate: Date today.
	result computedAt: DateAndTime now.
	^result
]

{ #category : 'private' }
BgScheduler >> topologicalSort: schedulableItems [
	| inDegree queue sorted restricted effectiveMap sortBlock |
	restricted := schedulableItems asIdentitySet.
	effectiveMap := self effectivePriorityMap: schedulableItems.
	sortBlock := [ :a :b |
		| pa pb |
		pa := effectiveMap at: a.
		pb := effectiveMap at: b.
		pa = pb
			ifTrue: [ (a estimate ifNil: [ 0 ]) <= (b estimate ifNil: [ 0 ]) ]
			ifFalse: [ pa <= pb ] ].
	inDegree := IdentityDictionary new.
	schedulableItems do: [ :item | inDegree at: item put: 0 ].
	schedulableItems do: [ :item |
		item dependencies do: [ :dep |
			(restricted includes: dep) ifTrue: [
				inDegree at: item put: (inDegree at: item) + 1 ] ] ].
	queue := (schedulableItems select: [ :item | (inDegree at: item) = 0 ])
		asSortedCollection: sortBlock.
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
					queue := queue asSortedCollection: sortBlock ] ] ] ].
	^ sorted
]
