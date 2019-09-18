"
I am a Slide designe that gets a Text and and Element and displays them. I can be included in presentations.
"
Class {
	#name : #GtTextAndElementSlide,
	#superclass : #GtSlide,
	#instVars : [
		'text',
		'elementBlock'
	],
	#category : #'GToolkit-Presenter'
}

{ #category : #'api - instantiation' }
GtTextAndElementSlide >> create [
	| container |
	container := BlElement new
		constraintsDo: [:c |
			c horizontal matchParent.
			c vertical matchParent ];
		padding: (BlInsets top: 20 bottom: 20);
		layout: BlLinearLayout vertical;
		addChild: (BlTextElement new
				constraintsDo: [ :c |
					c vertical fitContent.
					c horizontal fitContent.
					c linear horizontal alignCenter];
				text: text);
		addChild: (BlElement new
			constraintsDo: [:ct |
				ct vertical matchParent.
				ct horizontal matchParent ];
			layout: BlLinearLayout vertical;
			margin: (BlInsets all: 20);
			addChild: (elementBlock value constraintsDo: [:c | c horizontal matchParent. c vertical matchParent ])).
	^ container
]

{ #category : #accessing }
GtTextAndElementSlide >> element: anElement [
	elementBlock := anElement.
]

{ #category : #initialization }
GtTextAndElementSlide >> initialize [
	super initialize.
	self text: ''.
	self element: nil.
]

{ #category : #accessing }
GtTextAndElementSlide >> stencil: aBlock [
	elementBlock := aBlock.
]

{ #category : #accessing }
GtTextAndElementSlide >> text: aText [
	self textWithFormat: (aText asRopedText fontSize: 30; glamorousRegularFont)
]

{ #category : #'as yet unclassified' }
GtTextAndElementSlide >> textWithFormat: aText [
	text := aText.
]