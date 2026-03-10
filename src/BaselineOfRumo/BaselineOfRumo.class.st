Class {
	#name : 'BaselineOfRumo',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRumo',
	#package : 'BaselineOfRumo'
}

{ #category : 'baselines' }
BaselineOfRumo >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Bloc'
			with: [ spec repository: 'github://pharo-graphics/Bloc:v2.1.0/src' ].
		spec
			baseline: 'Toplo'
			with: [ spec repository: 'github://pharo-graphics/Toplo:master/src' ].

		spec
			package: 'GanttTracker-Bloc'
			with: [ spec requires: #('Bloc' 'Toplo') ].
		spec
			package: 'GanttTracker-Bloc-Tests'
			with: [ spec requires: #('GanttTracker-Bloc') ].

		spec
			group: 'Core' with: #('GanttTracker-Bloc');
			group: 'Tests' with: #('GanttTracker-Bloc-Tests');
			group: 'default' with: #('Core' 'Tests') ]
]
