Class {
	#name : #GtSlidesHudsonReport,
	#superclass : #GtExamplesTestingHudsonReport,
	#category : #'GToolkit-Presenter-Runtime'
}

{ #category : #running }
GtSlidesHudsonReport class >> runPackage: aString [
	^ self new 
		initializeWithTestCases: (RPackage organizer packageNamed: aString) gtSlidesAllContained;
		reportName: aString;
		run
]

{ #category : #running }
GtSlidesHudsonReport class >> runPackages: aCollectionOfStrings [
	^ aCollectionOfStrings collect: [ :each | 
		self runPackage: each ]
]

{ #category : #'accessing - test case' }
GtSlidesHudsonReport >> containerNameFor: aSlide [
	| definingClass |
	definingClass := aSlide definingMethod methods last methodClass.

	^ (definingClass category copyReplaceAll: '-' with: '.'),
		'.',
		definingClass name
		
]

{ #category : #'accessing - test case' }
GtSlidesHudsonReport >> loggingNameFor: anExample [
	| definingMethod |
	definingMethod := anExample definingMethod methods last.
	^ definingMethod methodClass name, '>>', definingMethod selector
]

{ #category : #'accessing - test case' }
GtSlidesHudsonReport >> nameFor: aSlide [
	^ aSlide definingMethod methods last selector
]

{ #category : #accessing }
GtSlidesHudsonReport >> resultsFileName [
	^ self reportName , '-Slides.xml'
]

{ #category : #running }
GtSlidesHudsonReport >> runSlide: aSlide [
	| error stack |
	self
		beginTestCase: aSlide
		runBlock: [
			[ aSlide run ]
				on: Halt , Error , AssertionFailure
				do: [ :err | 
					error := err.
					stack := self stackTraceString: err of: aSlide ] ].
			
	error ifNotNil: [
		(error isKindOf: AssertionFailure)
			ifTrue: [ self writeFailure: error stack: stack ]
			ifFalse: [ self writeError: error stack: stack ] ].
	
	self endTestCase
]

{ #category : #running }
GtSlidesHudsonReport >> runTestCase: anExample [
	^ self runSlide: anExample
]

{ #category : #private }
GtSlidesHudsonReport >> stackTraceString: err of: aTestCase [
	^ String streamContents: [ :str | 
		| context |
		context := err signalerContext.
		[ context isNil or: [ context receiver == aTestCase and: [ context methodSelector == #run ] ] ] whileFalse: [
			[str print: context; lf.] ifError: [ str nextPutAll: 'PRINTING ERROR'; lf].
			context := context sender ] ] 
]