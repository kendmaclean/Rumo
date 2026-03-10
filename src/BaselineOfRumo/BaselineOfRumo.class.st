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
			package: 'GanttTracker-Bloc';
			package: 'GanttTracker-Bloc-Tests' with: [ spec requires: #('GanttTracker-Bloc') ].

		spec
			group: 'Core' with: #('GanttTracker-Bloc');
			group: 'Tests' with: #('GanttTracker-Bloc-Tests');
			group: 'default' with: #('Core' 'Tests') ]
]
