Class {
	#name : 'BgHorizontalScrollBar',
	#superclass : 'BlElement',
	#instVars : [
		'thumb',
		'onScrolled',
		'visibleWidth',
		'totalWidth',
		'currentOffset',
		'isDragging',
		'dragStartScreenX',
		'dragStartOffset',
		'thumbWidth'
	],
	#category : 'Rumo',
	#package : 'Rumo'
}

{ #category : 'api' }
BgHorizontalScrollBar >> currentOffset [
	^ currentOffset
]

{ #category : 'initialization' }
BgHorizontalScrollBar >> initialize [
	super initialize.
	visibleWidth := 0.
	totalWidth := 0.
	currentOffset := 0.
	thumbWidth := 0.
	self layout: BlBasicLayout new.
	self clipChildren: true.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: 14 ].
	self background: (BlColorPaint color: (Color gray alpha: 0.12)).
	thumb := BlElement new.
	thumb background: (BlColorPaint color: (Color gray alpha: 0.5)).
	thumb geometry: (BlRoundedRectangleGeometry cornerRadius: 5).
	thumb constraintsDo: [ :c |
		c horizontal exact: 0.
		c vertical exact: 10 ].
	thumb position: 0 @ 2.
	self addChild: thumb.
	self visibility: BlVisibility gone.
	thumb addEventHandler: (BlPullHandler new disallowOutOfBounds; beHorizontal; yourself).
	thumb addEventHandlerOn: BlPullEvent
		do: [ :evt | self onThumbPulledTo: evt currentPosition ]
]

{ #category : 'api' }
BgHorizontalScrollBar >> onScrolled: aBlock [
	onScrolled := aBlock
]

{ #category : 'private' }
BgHorizontalScrollBar >> onThumbPulledTo: aPoint [
	| trackW maxOffset fraction |
	trackW := self extent x.
	maxOffset := totalWidth - visibleWidth.
	maxOffset <= 0 ifTrue: [ ^ self ].
	fraction := (trackW - thumbWidth) > 0
		ifTrue: [ ((aPoint x / (trackW - thumbWidth)) max: 0.0) min: 1.0 ]
		ifFalse: [ 0.0 ].
	currentOffset := (fraction * maxOffset) truncated.
	onScrolled ifNotNil: [ :cb | cb value: currentOffset ]
]

{ #category : 'api' }
BgHorizontalScrollBar >> updateFor: vis totalWidth: tot [
	| trackW |
	visibleWidth := vis.
	totalWidth := tot.
	tot <= vis ifTrue: [
		self visibility: BlVisibility gone.
		^ self ].
	self visibility: BlVisibility visible.
	trackW := self extent x.
	trackW = 0 ifTrue: [ ^ self ].
	thumbWidth := ((vis / tot * trackW) truncated) max: 30.
	thumb constraintsDo: [ :c | c horizontal exact: thumbWidth ].
	currentOffset := currentOffset min: tot - vis.
	self updateThumbPosition
]

{ #category : 'private' }
BgHorizontalScrollBar >> updateThumbPosition [
	| trackW maxOffset fraction thumbX |
	trackW := self extent x.
	maxOffset := totalWidth - visibleWidth.
	fraction := maxOffset <= 0
		ifTrue: [ 0.0 ]
		ifFalse: [ currentOffset / maxOffset ].
	thumbX := (fraction * (trackW - thumbWidth)) truncated max: 0.
	thumb position: thumbX @ 2
]
