Class {
	#name : 'BgGanttPresenter',
	#superclass : 'SpBlSpaceInMorphPresenter',
	#instVars : [
		'listElement',
		'arrowOverlay',
		'headerElement',
		'filterField',
		'scheduleResult',
		'onSelectionChanged',
		'onContextMenu',
		'selectedItem',
		'allScheduledItems'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'constants' }
BgGanttPresenter class >> dayWidth [
	^20
]

{ #category : 'constants' }
BgGanttPresenter class >> headerHeight [
	^30
]

{ #category : 'constants' }
BgGanttPresenter class >> labelWidth [
	^320
]

{ #category : 'constants' }
BgGanttPresenter class >> rowHeight [
	^28
]

{ #category : 'private' }
BgGanttPresenter >> applyFilter [
	| pattern filtered |
	pattern := filterField text asString trimBoth.
	filtered := pattern isEmpty
		ifTrue: [ allScheduledItems ]
		ifFalse: [
			allScheduledItems select: [ :si |
				si item title ifNil: [ true ] ifNotNil: [ :t |
					t asLowercase includesSubstring: pattern asLowercase ] ] ].
	listElement dataAccessor removeAll.
	listElement dataAccessor addAllLast: filtered
]

{ #category : 'private - building' }
BgGanttPresenter >> assembleRoot [
	| contentArea |
	contentArea := BlElement new.
	contentArea layout: BlFrameLayout new.
	contentArea constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent.
		c linear weight: 1 ].
	contentArea addChild: listElement.
	contentArea addChild: arrowOverlay.
	listElement addEventHandlerOn: BlElementScrolledEvent
		do: [ :evt | arrowOverlay scrollOffset: arrowOverlay scrollOffset + evt delta y ].
	space root layout: BlLinearLayout vertical.
	space root constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	space root addChild: filterField.
	space root addChild: headerElement.
	space root addChild: contentArea
]

{ #category : 'private - building' }
BgGanttPresenter >> buildFilterField [
	filterField := ToTextField new.
	filterField placeholderText: 'Filter items...'.
	filterField constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 28 ].
	filterField addEventHandlerOn: AlbTextEditedEvent do: [ self applyFilter ]
]

{ #category : 'private - building' }
BgGanttPresenter >> buildHeader [
	headerElement := BgTimelineHeaderElement new
]

{ #category : 'private - building' }
BgGanttPresenter >> buildList [
	listElement := ToListElement new.
	listElement matchParent.
	listElement nodeBuilder: [ :node :si :holder |
		| item icon titleText estimateText idx labelEl barEl |
		item := si item.
		idx := listElement dataAccessor indexOf: si ifAbsent: [ 0 ].
		icon := item isTask ifTrue: [ 'T' ] ifFalse: [ 'B' ].
		titleText := item title ifNil: [ 'untitled' ].
		estimateText := item estimate
			ifNil: [ '?' ]
			ifNotNil: [ :e | e printString , 'd' ].
		labelEl := BlTextElement new.
		labelEl text: (idx printString , ' ' , icon , ' ' , titleText
			, ' (' , estimateText , ')') asRopedText.
		labelEl constraintsDo: [ :c |
			c horizontal exact: BgGanttPresenter labelWidth.
			c vertical exact: BgGanttPresenter rowHeight.
			c linear vertical alignCenter ].
		item status = #blocked
			ifTrue: [ labelEl text foreground: Color gray ].
		barEl := BgGanttBarElement new.
		barEl scheduledItem: si.
		barEl onSelectionChanged: onSelectionChanged.
		barEl onContextMenu: onContextMenu.
		barEl constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical exact: BgGanttPresenter rowHeight ].
		node removeChildren.
		node layout: BlLinearLayout horizontal.
		node addChild: labelEl.
		node addChild: barEl ].
	listElement addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :evt |
			| idxs |
			idxs := listElement selecter selectedIndexes.
			(idxs notEmpty and: [ idxs anyOne <= listElement dataAccessor size ]) ifTrue: [
				| si |
				si := listElement dataAccessor at: idxs anyOne.
				selectedItem := si item.
				onSelectionChanged ifNotNil: [ :cb | cb value: si item ] ] ]
]

{ #category : 'private - building' }
BgGanttPresenter >> buildOverlay [
	arrowOverlay := BgArrowOverlayElement new
]

{ #category : 'api' }
BgGanttPresenter >> highlightItem: aBgItem [

	| idx |
	idx := listElement dataAccessor
		       detectIndex: [ :si | si item == aBgItem ]
		       ifNone: [ ^ self ].
	listElement scrollToDataSourcePosition: idx.
	listElement selecter selectOnlyIndex: idx
]

{ #category : 'initialization' }
BgGanttPresenter >> initializePresenters [
	super initializePresenters.
	space toTheme: ToBeeTheme new.
	self buildList.
	self buildFilterField.
	self buildHeader.
	self buildOverlay.
	self assembleRoot
]

{ #category : 'api' }
BgGanttPresenter >> loadScheduleResult: aBgScheduleResult [
	scheduleResult := aBgScheduleResult.
	allScheduledItems := aBgScheduleResult scheduledItems.
	headerElement buildFor: aBgScheduleResult.
	listElement selecter deselectAll.
	self applyFilter.
	arrowOverlay scheduleResult: aBgScheduleResult
]

{ #category : 'accessing' }
BgGanttPresenter >> onContextMenu: aBlock [
	onContextMenu := aBlock
]

{ #category : 'accessing' }
BgGanttPresenter >> onSelectionChanged: aBlock [
	onSelectionChanged := aBlock
]
