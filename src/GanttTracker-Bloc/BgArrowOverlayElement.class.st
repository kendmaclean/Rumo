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
	| itemToSi rowIndexOf rh dw lw color hOff sOff |
	self removeChildren.
	scheduleResult ifNil: [ ^self ].
	rh := BgGanttPresenter rowHeight.
	dw := BgGanttPresenter dayWidth.
	lw := BgGanttPresenter labelWidth.
	hOff := horizontalOffset ifNil: [ 0 ].
	sOff := scrollOffset ifNil: [ 0 ].
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
					| depRow fromX fromY midX minY segH segStartX segW cFromX cToX |
					depRow := rowIndexOf at: depSi.
					fromX := lw + (depSi endDay * dw) - hOff.
					fromY := (depRow * rh) + (rh // 2) - sOff.
					(fromX < lw and: [ toX < lw ]) ifFalse: [
						cFromX := fromX max: lw.
						cToX := toX max: lw.
						midX := cFromX + 8.
						self addChild: (self makeSegmentX: cFromX y: fromY width: 8 height: 2 color: color).
						minY := fromY min: toY.
						segH := (fromY - toY) abs max: 1.
						self addChild: (self makeSegmentX: midX y: minY width: 2 height: segH color: color).
						segStartX := midX min: cToX.
						segW := (cToX - midX) abs max: 1.
						self addChild: (self makeSegmentX: segStartX y: toY width: segW height: 2 color: color) ] ] ] ] ]
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
