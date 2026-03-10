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
			package: 'Rumo'
			with: [ spec requires: #('Bloc' 'Toplo') ].
		spec
			package: 'Rumo-Tests'
			with: [ spec requires: #('Rumo') ].

		spec
			group: 'Core' with: #('Rumo');
			group: 'Tests' with: #('Rumo-Tests');
			group: 'default' with: #('Core' 'Tests') ]
]
