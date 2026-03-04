Class {
	#name : 'BgArrowOverlayElement',
	#superclass : 'BlElement',
	#instVars : [
		'scheduleResult',
		'scrollOffset'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'private' }
BgArrowOverlayElement >> buildArrows [
	| itemToSi rowIndexOf rh dw lw color |
	self removeChildren.
	scheduleResult ifNil: [ ^self ].
	rh := BgGanttPresenter rowHeight.
	dw := BgGanttPresenter dayWidth.
	lw := BgGanttPresenter labelWidth.
	color := Color blue alpha: 0.55.
	itemToSi := IdentityDictionary new.
	rowIndexOf := IdentityDictionary new.
	scheduleResult scheduledItems doWithIndex: [ :si :i |
		itemToSi at: si item put: si.
		rowIndexOf at: si put: i - 1 ].
	scheduleResult scheduledItems do: [ :si |
		| siRow toX toY |
		siRow := rowIndexOf at: si.
		toX := lw + (si startDay * dw).
		toY := (siRow * rh) + (rh // 2) - scrollOffset.
		si item dependencies do: [ :dep |
			| depSi depRow fromX fromY midX minY segH segStartX segW |
			depSi := itemToSi at: dep ifAbsent: [ nil ].
			depSi ifNotNil: [
				depRow := rowIndexOf at: depSi.
				fromX := lw + (depSi endDay * dw).
				fromY := (depRow * rh) + (rh // 2) - scrollOffset.
				midX := fromX + 8.
				self addChild: (self makeSegmentX: fromX y: fromY width: 8 height: 2 color: color).
				minY := fromY min: toY.
				segH := (fromY - toY) abs max: 1.
				self addChild: (self makeSegmentX: midX y: minY width: 2 height: segH color: color).
				segStartX := midX min: toX.
				segW := (toX - midX) abs max: 1.
				self addChild: (self makeSegmentX: segStartX y: toY width: segW height: 2 color: color) ] ] ]
]

{ #category : 'geometry testing' }
BgArrowOverlayElement >> containsPoint: aPoint [
	"Pass all mouse events through to the list beneath"
	^false
]

{ #category : 'initialization' }
BgArrowOverlayElement >> initialize [
	super initialize.
	scrollOffset := 0.
	self layout: BlBasicLayout new.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ]
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
