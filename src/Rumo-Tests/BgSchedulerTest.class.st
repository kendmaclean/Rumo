Class {
	#name : 'BgSchedulerTest',
	#superclass : 'TestCase',
	#category : 'Rumo-Tests',
	#package : 'Rumo-Tests'
}

{ #category : 'tests' }
BgSchedulerTest >> testScheduleEmptyCollection [
	| scheduler result |
	scheduler := BgScheduler new.
	result := scheduler scheduleAll: #().
	self assert: result scheduledItems isEmpty
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleInProgressIncluded [
	| scheduler item result |
	scheduler := BgScheduler new.
	item := BgItem new status: #inProgress; estimate: 3; yourself.
	result := scheduler scheduleAll: { item }.
	self assert: result scheduledItems size equals: 1.
	self assert: result scheduledItems first endDay equals: 3
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleItemWithNilEstimate [
	| scheduler item result scheduled |
	scheduler := BgScheduler new.
	item := BgItem new
		title: 'Task';
		estimate: nil;
		yourself.
	result := scheduler scheduleAll: { item }.
	scheduled := result scheduledItems first.
	self assert: scheduled startDay equals: 0.
	self assert: scheduled endDay equals: 0
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleRespectsEstimateWhenSamePriority [
	| scheduler short long result ss sl |
	scheduler := BgScheduler new.
	short := BgItem new priority: #medium; estimate: 1; yourself.
	long := BgItem new priority: #medium; estimate: 5; yourself.
	result := scheduler scheduleAll: { short. long }.
	ss := result scheduledItems detect: [ :si | si item == short ].
	sl := result scheduledItems detect: [ :si | si item == long ].
	self assert: ss startDay < sl startDay
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleRespectsPriority [
	| scheduler critical high medium low result items |
	scheduler := BgScheduler new.
	critical := BgItem new priority: #critical; estimate: 1; yourself.
	high := BgItem new priority: #high; estimate: 1; yourself.
	medium := BgItem new priority: #medium; estimate: 1; yourself.
	low := BgItem new priority: #low; estimate: 1; yourself.
	items := { critical. high. medium. low }.
	result := scheduler scheduleAll: items.
	self assert: (result scheduledItems collect: [ :si | si item priority ]) asArray
		equals: #(critical high medium low)
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleRespectsStatus [
	| scheduler openItem blockedItem doneItem result |
	scheduler := BgScheduler new.
	openItem := BgItem new status: #open; estimate: 3; yourself.
	blockedItem := BgItem new status: #blocked; estimate: 3; yourself.
	doneItem := BgItem new status: #done; estimate: 3; yourself.
	result := scheduler scheduleAll: { openItem. blockedItem. doneItem }.
	self assert: result scheduledItems size equals: 3.
	result scheduledItems do: [ :si |
		(si item status = #open)
			ifTrue: [ self assert: si endDay > 0 ].
		(si item status = #blocked)
			ifTrue: [ self assert: si startDay equals: 0. self assert: si endDay equals: 0 ].
		(si item status = #done)
			ifTrue: [ self assert: si startDay equals: 0 ] ]
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleSingleItem [
	| scheduler item result scheduled |
	scheduler := BgScheduler new.
	item := BgItem new
		title: 'Task 1';
		estimate: 5;
		yourself.
	result := scheduler scheduleAll: { item }.
	self assert: result scheduledItems size equals: 1.
	scheduled := result scheduledItems first.
	self assert: scheduled item identicalTo: item.
	self assert: scheduled startDay equals: 0.
	self assert: scheduled endDay equals: 5
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleWithChainedDependencies [
	| scheduler a b c result sa sb sc |
	scheduler := BgScheduler new.
	a := BgItem new title: 'A'; estimate: 2; yourself.
	b := BgItem new title: 'B'; estimate: 3; yourself.
	c := BgItem new title: 'C'; estimate: 4; yourself.
	b dependencies add: a.
	c dependencies add: b.
	result := scheduler scheduleAll: { a. b. c }.
	sa := result scheduledItems detect: [ :si | si item == a ].
	sb := result scheduledItems detect: [ :si | si item == b ].
	sc := result scheduledItems detect: [ :si | si item == c ].
	self assert: sa startDay equals: 0.
	self assert: sa endDay equals: 2.
	self assert: sb startDay equals: 2.
	self assert: sb endDay equals: 5.
	self assert: sc startDay equals: 5.
	self assert: sc endDay equals: 9
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleWithDependency [
	| scheduler dep item result scheduledItem scheduledDep |
	scheduler := BgScheduler new.
	dep := BgItem new
		title: 'Dependency';
		estimate: 3;
		yourself.
	item := BgItem new
		title: 'Task';
		estimate: 5;
		yourself.
	item dependencies add: dep.
	result := scheduler scheduleAll: { dep. item }.
	self assert: result scheduledItems size equals: 2.
	scheduledDep := result scheduledItems detect: [ :si | si item == dep ].
	scheduledItem := result scheduledItems detect: [ :si | si item == item ].
	self assert: scheduledDep startDay equals: 0.
	self assert: scheduledDep endDay equals: 3.
	self assert: scheduledItem startDay equals: 3.
	self assert: scheduledItem endDay equals: 8
]

{ #category : 'tests' }
BgSchedulerTest >> testScheduleWithMultipleDependencies [
	| scheduler dep1 dep2 item result scheduledItem |
	scheduler := BgScheduler new.
	dep1 := BgItem new estimate: 3; yourself.
	dep2 := BgItem new estimate: 7; yourself.
	item := BgItem new estimate: 2; yourself.
	item dependencies add: dep1.
	item dependencies add: dep2.
	result := scheduler scheduleAll: { dep1. dep2. item }.
	scheduledItem := result scheduledItems detect: [ :si | si item == item ].
	self assert: scheduledItem startDay equals: 10.
	self assert: scheduledItem endDay equals: 12
]
