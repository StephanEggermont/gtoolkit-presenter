Class {
	#name : #GtLiveSlidesSortHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'originalPosition',
		'dragStartPosition',
		'overlay',
		'parent',
		'placeholder',
		'dropBlock'
	],
	#category : #'GToolkit-Presenter'
}

{ #category : #'event handling' }
GtLiveSlidesSortHandler >> dragEndEvent: anEvent [
	"anEvent consumed: true."
	| draggable |
	draggable := anEvent currentTarget.
	overlay ifNotNil: [
		overlay removeChild: draggable.
		parent replaceChild: placeholder with: draggable.
		overlay detach].
	dropBlock ifNotNil: [dropBlock value].
	anEvent currentTarget dispatchEvent: BlPullEndEvent new
]

{ #category : #'event handling' }
GtLiveSlidesSortHandler >> dragEvent: anEvent [
	| dragPosition dragDelta aNewPosition |
	dragPosition := anEvent currentTarget
		globalPointToParent: anEvent position.
	self movePlaceholderIfOverOtherChild: anEvent.
	dragDelta := dragPosition
		- (dragStartPosition ifNil: [ dragStartPosition := dragPosition ]).
	aNewPosition := (originalPosition
		ifNil: [ originalPosition := anEvent currentTarget position ])
		+ dragDelta.
	anEvent currentTarget relocate: aNewPosition.
	anEvent consumed: true.
	anEvent currentTarget
		dispatchEvent:
			(BlPullEvent new
				initialPosition: originalPosition;
				oldPosition: dragPosition;
				newPosition: aNewPosition;
				delta: dragDelta)
]

{ #category : #'event handling' }
GtLiveSlidesSortHandler >> dragStartEvent: anEvent [
	|draggable |
	anEvent consumed: true.
	draggable := anEvent currentTarget.
	parent := draggable parent.
	overlay := BlOverlayElement on: parent.
	parent parent addChild: overlay.

	"drag start position in parent"
	dragStartPosition := draggable globalPointToParent: anEvent position.

	"element position in parent"
	originalPosition := draggable position.
	placeholder := self placeholderFor: draggable.
	parent replaceChild: draggable with: placeholder.
	overlay addChild: draggable.

	anEvent currentTarget dispatchEvent: BlPullStartEvent new
]

{ #category : #accessing }
GtLiveSlidesSortHandler >> dropBlock: aBlock [
	dropBlock := aBlock
]

{ #category : #'api - accessing' }
GtLiveSlidesSortHandler >> eventsToHandle [
	^ { BlDragStartEvent . BlDragEvent . BlDragEndEvent }
]

{ #category : #'event handling' }
GtLiveSlidesSortHandler >> movePlaceholderIfOverOtherChild: anEvent [
	| mouseOverOther |
	mouseOverOther := placeholder.
	parent children
		do: [ :each | 
			(each containsGlobalPoint: anEvent position)
				ifTrue: [ mouseOverOther := each ] ].
	mouseOverOther = placeholder
		ifFalse: [ | index |
			index := parent childIndexOf: mouseOverOther.
			parent removeChild: placeholder.
			parent addChild: placeholder at: index ]
]

{ #category : #'event handling' }
GtLiveSlidesSortHandler >> placeholderFor: draggable [ 
	^BlElement new
		size: draggable size;
		border: (draggable border copyWithStyle: BlStrokeStyle dashed);
		margin: draggable margin;
		background: (draggable background paint color alpha: 0.2);
		yourself
]
