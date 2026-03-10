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
			package: 'Rumo'
			with: [ spec requires: #() ].
		spec
			package: 'Rumo-Tests'
			with: [ spec requires: #('Rumo') ].

		spec
			group: 'Core' with: #('Rumo');
			group: 'Tests' with: #('Rumo-Tests');
			group: 'default' with: #('Core' 'Tests') ]
]
