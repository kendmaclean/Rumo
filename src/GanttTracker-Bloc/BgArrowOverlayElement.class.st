Class {
	#name : 'BgArrowOverlayElement',
	#superclass : 'BlElement',
	#instVars : [
		'scheduleResult',
		'scrollOffset',
		'horizontalOffset'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'private' }
BgArrowOverlayElement >> buildArrows [
	| itemToSi rowIndexOf rh dw lw color hOff sOff barHalf exitOffset |
	self removeChildren.
	scheduleResult ifNil: [ ^self ].
	rh := BgGanttPresenter rowHeight.
	dw := BgGanttPresenter dayWidth.
	lw := BgGanttPresenter labelWidth.
	hOff := horizontalOffset ifNil: [ 0 ].
	sOff := scrollOffset ifNil: [ 0 ].
	barHalf := 11. "half the bar height (22px bar)"
	exitOffset := 6. "px left of bar right edge"
	color := Color blue alpha: 0.55.
	itemToSi := IdentityDictionary new.
	rowIndexOf := IdentityDictionary new.
	scheduleResult scheduledItems doWithIndex: [ :si :i |
		itemToSi at: si item put: si.
		rowIndexOf at: si put: i - 1 ].
	scheduleResult scheduledItems do: [ :si |
		si startDay ifNotNil: [ :siStartDay |
			| siRow toX toY |
			siRow := rowIndexOf at: si.
			toX := lw + (siStartDay * dw) - hOff.
			toY := (siRow * rh) + (rh // 2) - sOff.
			si item dependencies do: [ :dep |
				| depSi |
				depSi := itemToSi at: dep ifAbsent: [ nil ].
				(depSi notNil and: [ depSi endDay notNil ]) ifTrue: [
					| depRow fromX fromY exitX exitY cToX segTop segH hStart |
					depRow := rowIndexOf at: depSi.
					fromX := lw + (depSi endDay * dw) - hOff.
					fromY := (depRow * rh) + (rh // 2) - sOff.
					(fromX < lw and: [ toX < lw ]) ifFalse: [
						exitX := (fromX - exitOffset) max: lw.
						exitY := toY >= fromY
							ifTrue: [ fromY + barHalf ]
							ifFalse: [ fromY - barHalf ].
						cToX := toX max: lw.
						segTop := exitY min: toY.
						segH := (toY - exitY) abs max: 1.
						self addChild: (self makeSegmentX: exitX y: segTop width: 2 height: segH color: color).
						hStart := exitX min: cToX.
						(cToX - hStart) > 0 ifTrue: [
							self addChild: (self makeSegmentX: hStart y: toY width: cToX - hStart height: 2 color: color) ].
						cToX >= lw ifTrue: [
							self addChild: (self makeArrowheadAt: cToX y: toY color: color) ] ] ] ] ] ]
]

{ #category : 'geometry testing' }
BgArrowOverlayElement >> containsPoint: aPoint [
	"Pass all mouse events through to the list beneath"
	^false
]

{ #category : 'accessing' }
BgArrowOverlayElement >> horizontalOffset: aNumber [
	horizontalOffset := aNumber.
	self buildArrows
]

{ #category : 'initialization' }
BgArrowOverlayElement >> initialize [
	super initialize.
	scrollOffset := 0.
	horizontalOffset := 0.
	self layout: BlBasicLayout new.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ]
]

{ #category : 'private' }
BgArrowOverlayElement >> makeArrowheadAt: x y: y color: aColor [
	| size tip |
	size := 7.
	tip := BlElement new.
	tip geometry: BlTriangleGeometry new beRight.
	tip background: aColor.
	tip constraintsDo: [ :c |
		c horizontal exact: size.
		c vertical exact: size ].
	tip position: x @ (y - (size // 2) + 1).
	^ tip
]

{ #category : 'private' }
BgArrowOverlayElement >> makeSegmentX: x y: y width: w height: h color: aColor [
	| seg |
	seg := BlElement new.
	seg background: aColor.
	seg position: x @ y.
	seg constraintsDo: [ :c |
		c horizontal exact: (w max: 1).
		c vertical exact: (h max: 1) ].
	^seg
]

{ #category : 'accessing' }
BgArrowOverlayElement >> scheduleResult: aBgScheduleResult [
	scheduleResult := aBgScheduleResult.
	self buildArrows
]

{ #category : 'accessing' }
BgArrowOverlayElement >> scrollOffset [
	^ scrollOffset
]

{ #category : 'accessing' }
BgArrowOverlayElement >> scrollOffset: aNumber [
	scrollOffset := aNumber.
	self buildArrows
]
