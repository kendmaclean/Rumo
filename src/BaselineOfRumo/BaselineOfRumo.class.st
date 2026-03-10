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
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
		spec
			package: 'Rumo'
			with: [ spec requires: #('NeoJSON') ].
		spec
			package: 'Rumo-Tests'
			with: [ spec requires: #('Rumo') ].
		spec
			group: 'Core' with: #('Rumo');
			group: 'Tests' with: #('Rumo-Tests');
			group: 'default' with: #('Core' 'Tests') ]
]
