Class {
	#name : 'BgDependencyValidatorTest',
	#superclass : 'TestCase',
	#category : 'GanttTracker-Bloc-Tests',
	#package : 'GanttTracker-Bloc-Tests'
}

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddCreatesDirectCycle [
	| validator a b |
	validator := BgDependencyValidator new.
	a := BgItem new.
	b := BgItem new.
	a dependencies add: b.
	self deny: (validator canAdd: a to: b)
]

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddCreatesIndirectCycle [
	| validator a b c |
	validator := BgDependencyValidator new.
	a := BgItem new.
	b := BgItem new.
	c := BgItem new.
	a dependencies add: b.
	b dependencies add: c.
	self deny: (validator canAdd: a to: c)
]

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddDeepCycle [
	| validator a b c d |
	validator := BgDependencyValidator new.
	a := BgItem new.
	b := BgItem new.
	c := BgItem new.
	d := BgItem new.
	a dependencies add: b.
	b dependencies add: c.
	c dependencies add: d.
	self deny: (validator canAdd: a to: d)
]

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddExistingDependency [
	| validator a b |
	validator := BgDependencyValidator new.
	a := BgItem new.
	b := BgItem new.
	a dependencies add: b.
	self deny: (validator canAdd: b to: a)
]

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddNoCycle [
	| validator a b c |
	validator := BgDependencyValidator new.
	a := BgItem new.
	b := BgItem new.
	c := BgItem new.
	a dependencies add: b.
	self assert: (validator canAdd: c to: a).
	self assert: (validator canAdd: c to: b)
]

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddSelfDependency [
	| validator item |
	validator := BgDependencyValidator new.
	item := BgItem new.
	self deny: (validator canAdd: item to: item)
]

{ #category : 'tests' }
BgDependencyValidatorTest >> testCanAddValidDependency [
	| validator a b |
	validator := BgDependencyValidator new.
	a := BgItem new.
	b := BgItem new.
	self assert: (validator canAdd: b to: a)
]
