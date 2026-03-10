Class {
	#name : 'BgTimelineHeaderElement',
	#superclass : 'BlElement',
	#instVars : [
		'scheduleResult',
		'dayStrip'
	],
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'building' }
BgTimelineHeaderElement >> buildFor: aBgScheduleResult [
	| spacer sepEl clipWrapper totalDays totalWidth todayLine todayOffset anchor months |
	scheduleResult := aBgScheduleResult.
	anchor := aBgScheduleResult anchorDate ifNil: [ Date today ].
	months := #('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun'
	            'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec').
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
	totalWidth := totalDays * BgGanttPresenter dayWidth.

	clipWrapper := BlElement new.
	clipWrapper clipChildren: true.
	clipWrapper layout: BlBasicLayout new.
	clipWrapper constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	dayStrip := BlElement new.
	dayStrip layout: BlBasicLayout new.
	dayStrip constraintsDo: [ :c |
		c horizontal exact: totalWidth.
		c vertical matchParent ].

	todayOffset := ((Date today - anchor) days max: 0) * BgGanttPresenter dayWidth.
	todayLine := BlElement new.
	todayLine background: (BlColorPaint color: (Color red alpha: 0.6)).
	todayLine position: todayOffset @ 0.
	todayLine size: 2 @ BgGanttPresenter headerHeight.
	dayStrip addChild: todayLine.

	0 to: totalDays by: 7 do: [ :day |
		| date lbl |
		date := anchor + day days.
		lbl := BlTextElement new.
		lbl text: ((months at: date monthIndex) , ' ' , date dayOfMonth printString) asRopedText.
		lbl position: (day * BgGanttPresenter dayWidth) @ 2.
		dayStrip addChild: lbl.

		day + 7 <= totalDays ifTrue: [
			| nextDate |
			nextDate := anchor + (day + 7) days.
			date monthIndex ~= nextDate monthIndex ifTrue: [
				| boundaryDay boundaryX sepLine monthLbl |
				boundaryDay := day + (date daysInMonth - date dayOfMonth + 1).
				boundaryX := boundaryDay * BgGanttPresenter dayWidth.
				sepLine := BlElement new.
				sepLine background: (BlColorPaint color: (Color gray alpha: 0.5)).
				sepLine position: boundaryX @ 0.
				sepLine size: 1 @ BgGanttPresenter headerHeight.
				dayStrip addChild: sepLine.
				monthLbl := BlTextElement new.
				monthLbl text: ((months at: nextDate monthIndex) , ' ' , nextDate year printString) asRopedText.
				monthLbl position: (boundaryX + 3) @ 14.
				dayStrip addChild: monthLbl ] ] ].

	clipWrapper addChild: dayStrip.
	self addChild: clipWrapper
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
