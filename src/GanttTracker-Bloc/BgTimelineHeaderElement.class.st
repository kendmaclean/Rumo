Class {
	#name : 'BgTimelineHeaderElement',
	#superclass : 'BlElement',
	#instVars : [
		'scheduleResult',
		'dayStrip'
	],
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'building' }
BgTimelineHeaderElement >> buildFor: aBgScheduleResult [
	| spacer sepEl totalDays todayLine |
	scheduleResult := aBgScheduleResult.
	self removeChildren.
	spacer := BlElement new.
	spacer constraintsDo: [ :c |
		c horizontal exact: BgGanttPresenter labelWidth.
		c vertical matchParent ].
	self addChild: spacer.
	sepEl := BlElement new.
	sepEl background: (BlColorPaint color: (Color gray alpha: 0.35)).
	sepEl constraintsDo: [ :c |
		c horizontal exact: 1.
		c vertical matchParent ].
	self addChild: sepEl.
	totalDays := (aBgScheduleResult scheduledItems
		inject: 0
		into: [ :max :si | max max: si endDay ]) ceiling + 14.
	dayStrip := BlElement new.
	dayStrip layout: BlBasicLayout new.
	dayStrip constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ].
	todayLine := BlElement new.
	todayLine background: (BlColorPaint color: (Color red alpha: 0.4)).
	todayLine position: 0 @ 0.
	todayLine size: 2 @ BgGanttPresenter headerHeight.
	dayStrip addChild: todayLine.
	0 to: totalDays by: 7 do: [ :day |
		| lbl |
		lbl := BlTextElement new.
		lbl text: day printString asRopedText.
		lbl position: (day * BgGanttPresenter dayWidth) @ 0.
		dayStrip addChild: lbl ].
	self addChild: dayStrip
]

{ #category : 'initialization' }
BgTimelineHeaderElement >> initialize [
	super initialize.
	self layout: BlLinearLayout horizontal.
	self constraintsDo: [ :c |
		c vertical exact: BgGanttPresenter headerHeight.
		c horizontal matchParent ].
	self background: (BlColorPaint color: (Color gray alpha: 0.07))
]

{ #category : 'api' }
BgTimelineHeaderElement >> xOffset: aNumber [
	dayStrip ifNil: [ ^ self ].
	dayStrip transformDo: [ :t | t translateBy: aNumber negated @ 0 ]
]
