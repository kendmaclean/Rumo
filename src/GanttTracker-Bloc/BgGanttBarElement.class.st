Class {
	#name : 'BgGanttBarElement',
	#superclass : 'BlElement',
	#instVars : [
		'scheduledItem',
		'barRect',
		'onSelectionChanged',
		'onContextMenu',
		'xOffset',
		'selectionState',
		'dimOverlay'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'private' }
BgGanttBarElement >> applySelectionVisuals [
	dimOverlay ifNotNil: [ dimOverlay removeFromParent. dimOverlay := nil ].
	barRect border: BlBorder empty.
	selectionState = #ineligible ifTrue: [
		dimOverlay := BlElement new.
		dimOverlay background: (BlColorPaint color: (Color white alpha: 0.65)).
		dimOverlay constraintsDo: [ :c |
			c frame horizontal alignLeft.
			c frame vertical alignCenter.
			c horizontal matchParent.
			c vertical exact: 22 ].
		self addChild: dimOverlay ].
	selectionState = #source ifTrue: [
		barRect border: (BlBorder paint: (Color blue alpha: 0.8) width: 2) ]
]

{ #category : 'private' }
BgGanttBarElement >> colorForStatus: aSymbol [
	^{	#open -> Color cyan darker.
		#inProgress -> Color orange.
		#done -> Color green darker.
		#blocked -> Color gray.
		#closed -> Color lightGray } asDictionary
			at: aSymbol ifAbsent: [ Color blue ]
]

{ #category : 'initialization' }
BgGanttBarElement >> initialize [
	super initialize.
	xOffset := 0.
	selectionState := #normal.
	self layout: BlFrameLayout new.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	barRect := BlElement new.
	barRect geometry: BlRectangleGeometry new.
	barRect constraintsDo: [ :c |
		c frame vertical alignCenter.
		c frame horizontal alignLeft.
		c vertical exact: 22.
		c horizontal exact: 0 ].
	self addChild: barRect.
	self addEventHandlerOn: BlClickEvent
		do: [
			(#(#ineligible #source) includes: selectionState) ifFalse: [
				onSelectionChanged ifNotNil: [ :cb | cb value: scheduledItem item ] ] ].
	self addEventHandlerOn: BlSecondaryClickEvent
		do: [
			(#(#ineligible #source) includes: selectionState) ifFalse: [
				onContextMenu ifNotNil: [ :cb | cb value: scheduledItem item ] ] ]
]

{ #category : 'accessing' }
BgGanttBarElement >> onContextMenu: aBlock [
	onContextMenu := aBlock
]

{ #category : 'accessing' }
BgGanttBarElement >> onSelectionChanged: aBlock [
	onSelectionChanged := aBlock
]

{ #category : 'private' }
BgGanttBarElement >> positionBar [
	| item startX endX width minWidth visStart visWidth |
	item := scheduledItem item.
	startX := scheduledItem startDay * BgGanttPresenter dayWidth.
	endX := scheduledItem endDay * BgGanttPresenter dayWidth.
	width := endX - startX.
	item status = #blocked ifTrue: [ ^ self showDiamondMarker ].
	item status = #done ifTrue: [
		barRect constraintsDo: [ :c | c horizontal exact: 0 ].
		^ self ].
	minWidth := BgGanttPresenter dayWidth / 4.
	width := width max: minWidth.
	visStart := startX - xOffset.
	visWidth := width.
	visStart < 0 ifTrue: [
		visWidth := (endX - xOffset) max: 0.
		visStart := 0 ].
	self padding: (BlInsets left: visStart).
	barRect geometry: BlRectangleGeometry new.
	barRect background: (BlColorPaint color: (self colorForStatus: item status)).
	barRect constraintsDo: [ :c |
		c frame horizontal alignLeft.
		c frame vertical alignCenter.
		c horizontal exact: visWidth.
		c vertical exact: 22 ]
]

{ #category : 'accessing' }
BgGanttBarElement >> scheduledItem: aBgScheduledItem [
	scheduledItem := aBgScheduledItem.
	self positionBar
]

{ #category : 'accessing' }
BgGanttBarElement >> selectionState: aSymbol [
	selectionState := aSymbol.
	self applySelectionVisuals
]

{ #category : 'accessing' }
BgGanttBarElement >> setXOffset: aNumber [
	xOffset := aNumber
]

{ #category : 'private' }
BgGanttBarElement >> showDiamondMarker [
	| startX diamondSize yPad leftPad |
	startX := scheduledItem startDay * BgGanttPresenter dayWidth.
	diamondSize := 12.
	yPad := (BgGanttPresenter rowHeight - diamondSize) / 2.
	leftPad := (startX - xOffset - 6) max: 0.
	self padding: (BlInsets top: yPad left: leftPad bottom: yPad right: 0).
	barRect geometry: (BlPolygonGeometry vertices: { 6@0. 12@6. 6@12. 0@6 }).
	barRect constraintsDo: [ :c |
		c frame horizontal alignLeft.
		c frame vertical alignTop.
		c horizontal exact: diamondSize.
		c vertical matchParent ].
	barRect background: (BlColorPaint color: Color darkGray)
]

{ #category : 'accessing' }
BgGanttBarElement >> xOffset: aNumber [
	xOffset := aNumber.
	self positionBar
]
