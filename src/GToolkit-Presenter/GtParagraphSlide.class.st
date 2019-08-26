Class {
	#name : #GtParagraphSlide,
	#superclass : #GtSlide,
	#instVars : [
		'subtitle',
		'paragraph'
	],
	#category : #'GToolkit-Presenter'
}

{ #category : #'api - instantiation' }
GtParagraphSlide >> create [ 

	^BlElement new 
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical matchParent ];
			layout: BlLinearLayout horizontal;
			addChild: (BrEditorElement new 
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent.
					"c horizontal alignCenter." ];
				editor: (BrTextEditor new 
					text: self fullText)).
]

{ #category : #accessing }
GtParagraphSlide >> fullText [

	^'' asRopedText
		append: subtitle;
		append: String cr asRopedText;
		append: paragraph;
		yourself
]

{ #category : #initialization }
GtParagraphSlide >> initialize [ 

	super initialize.
	self subtitle: ''.
	self paragraph: ''.
]

{ #category : #accessing }
GtParagraphSlide >> paragraph: aString [

	paragraph := aString asRopedText fontSize: 30; glamorousRegularFont
]

{ #category : #accessing }
GtParagraphSlide >> subtitle: aString [

	subtitle := aString asRopedText fontSize: 40; glamorousRegularFont
]