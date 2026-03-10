Class {
	#name : 'BgArrowOverlayElement',
	#superclass : 'BlElement',
	#instVars : [
		'scheduleResult',
		'scrollOffset',
		'horizontalOffset',
		'visibleItems'
	],
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'private' }
BgArrowOverlayElement >> buildArrows [
	| itemToSi rowIndexOf rh dw lw color hOff sOff barHalf exitOffset |
	self removeChildren.
	(scheduleResult isNil or: [ visibleItems isEmpty ]) ifTrue: [ ^self ].
	rh := BgGanttPresenter rowHeight.
	dw := BgGanttPresenter dayWidth.
	lw := BgGanttPresenter labelWidth.
	hOff := horizontalOffset ifNil: [ 0 ].
	sOff := scrollOffset ifNil: [ 0 ].
	barHalf := 11.
	exitOffset := 6.
	color := Color blue alpha: 0.55.

	"All scheduled items → geometry lookup (includes hidden items)"
	itemToSi := IdentityDictionary new.
	scheduleResult scheduledItems do: [ :si | itemToSi at: si item put: si ].

	"Only visible items → row index (drives arrow positions)"
	rowIndexOf := IdentityDictionary new.
	visibleItems doWithIndex: [ :si :i | rowIndexOf at: si put: i - 1 ].

	visibleItems do: [ :si |
		si startDay ifNotNil: [ :siStartDay |
			| siRow toX toY |
			siRow := rowIndexOf at: si ifAbsent: [ nil ].
			siRow ifNotNil: [
				toX := lw + (siStartDay * dw) - hOff.
				toY := (siRow * rh) + (rh // 2) - sOff.
				si item dependencies do: [ :dep |
					| depSi depRow |
					depSi := itemToSi at: dep ifAbsent: [ nil ].
					depRow := depSi ifNotNil: [ rowIndexOf at: depSi ifAbsent: [ nil ] ].
					(depRow notNil and: [ depSi endDay notNil ]) ifTrue: [
						| fromX fromY exitX exitY cToX segTop segH hStart |
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
								self addChild: (self makeArrowheadAt: cToX y: toY color: color) ] ] ] ] ] ] ]
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
	visibleItems := #().
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
	scheduleResult := aBgScheduleResult
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

{ #category : 'accessing' }
BgArrowOverlayElement >> visibleItems: aCollection [
	visibleItems := aCollection.
	self buildArrows
]
