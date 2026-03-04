Class {
	#name : 'BgDependencyValidator',
	#superclass : 'Object',
	#category : 'GanttTracker-Bloc',
	#package : 'GanttTracker-Bloc'
}

{ #category : 'validation' }
BgDependencyValidator >> canAdd: depItem to: item [
	(item == depItem) ifTrue: [ ^false ].
	(item dependencies includes: depItem) ifTrue: [ ^false ].
	^(self wouldCreateCycle: depItem in: item) not
]

{ #category : 'private' }
BgDependencyValidator >> checkCycle: current reachesTarget: target visited: visited [
	(visited includes: current) ifTrue: [ ^false ].
	visited add: current.
	^current dependencies anySatisfy: [ :dep |
		dep == target or: [
			self checkCycle: dep reachesTarget: target visited: visited ] ]
]

{ #category : 'private' }
BgDependencyValidator >> wouldCreateCycle: depItem in: item [
	| visited |
	visited := IdentitySet new.
	^self checkCycle: depItem reachesTarget: item visited: visited
]
