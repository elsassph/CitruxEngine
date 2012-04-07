package com.citruxengine.core;

import com.citruxengine.core.Input;
import com.citruxengine.core.State;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Lib;

/**
 * CitruxEngine is the top-most class in the library. When you start your project, you should make your
 * document class extend this class.
 * 
 * <p>CitruxEngine is a singleton so that you can grab a reference to it anywhere, anytime. Don't abuse this power,
 * but use it wisely. With it, you can quickly grab a reference to the manager classes such as current State, Input and SoundManager.</p>
 */	
class CitruxEngine extends Sprite {

	static private var _instance:CitruxEngine;

	public var state(getState, setState):State;
	public var playing(getPlaying, setPlaying):Bool;
	public var input(getInput, never):Input;

	var _state:State;
	var _newState:State;
	var _stateDisplayIndex:Int;

	var _playing:Bool;

	var _input:Input;

	var _startTime:Float;
	var _gameTime:Float;
	
	/**
	 * Extend your document class with CitruxEngine and don't forget to call super() !
	 */
	public function new() {
		
		super();

		_instance = this;

		_stateDisplayIndex = 0;

		_playing = true;

		_startTime = Date.now().getTime();
		_gameTime = _startTime;

		//Set up input
		_input = new Input();

		this.addEventListener(Event.ENTER_FRAME, _handleEnterFrame);
		this.addEventListener(Event.ADDED_TO_STAGE, _handleAddedToStage);
	}

	static public function getInstance():CitruxEngine {

		return _instance;
	}

	/**
	 * This is the game loop. It switches states if necessary, then calls update on the current state.
	 */
	private function _handleEnterFrame(evt:Event):Void {

		//Change states if it has been requested
		if (_newState != null) {

			if (_state != null)
				_state.destroy();

			_state = _newState;
			_newState = null;

			this.addChildAt(_state, _stateDisplayIndex);

			_state.initialize();
		}

		//Update the state
		if (_state != null && _playing) {

			var nowTime:Float = Date.now().getTime();
			var timeSinceLastFrame:Float = nowTime - _gameTime;
			var timeDelta:Float = timeSinceLastFrame * 0.001;
			_gameTime = nowTime;

			_state.update(timeDelta);
		}
	}

	/**
	 * A reference to the active game state. Acutally, that's not entirely true. If you've recently changed states and a tick
	 * hasn't occured yet, then this will reference your new state; this is because actual state-changes only happen pre-tick.
	 * That way you don't end up changing states in the middle of a state's tick, effectively fucking stuff up. 
	 */	
	public function getState():State {
		return (_newState != null) ? _newState : _state;
	}
	
	/**
	 * We only ACTUALLY change states on enter frame so that we don't risk changing states in the middle of a state update.
	 * However, if you use the state getter, it will grab the new one for you, so everything should work out just fine.
	 */	
	public function setState(value:State):State {
		return _newState = value;
	}

	/**
	 * Runs and pauses the game loop. Assign this to false to pause the game and stop the
	 * <code>update()</code> methods from being called. 
	 */	
	public function getPlaying():Bool {
		return _playing;
	}

	public function setPlaying(value:Bool):Bool {

		_playing = value;

		if (_playing)
			_gameTime = Date.now().getTime();

		return _playing;
	}

	/**
	 * You can get to my Input manager object from this reference so that you can see which keys are pressed and stuff. 
	 */		
	public function getInput():Input {
		return _input;
	}

	/**
	 * Set up things that need the stage access.
	 */
	 private function _handleAddedToStage(evt:Event):Void {

	 	this.removeEventListener(Event.ADDED_TO_STAGE, _handleAddedToStage);

	 	Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.addEventListener(Event.DEACTIVATE, _handleStageDeactivated);

		_input.initialize();
	 }

	 private function _handleStageDeactivated(evt:Event):Void {

	 	if (_playing) {

	 		_playing = false;
	 		Lib.current.stage.addEventListener(Event.ACTIVATE, _handleStageActivated);
	 	}
	 }

	 private function _handleStageActivated(evt:Event):Void {

	 	_playing = true;
	 	Lib.current.stage.removeEventListener(Event.ACTIVATE, _handleStageActivated);
	 }
}