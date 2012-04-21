package com.citruxengine.core;

import com.citruxengine.core.CitruxEngine;
import com.citruxengine.core.CitruxObject;
import com.citruxengine.core.Input;
import com.citruxengine.view.CitruxView;
import com.citruxengine.view.spriteview.SpriteView;

import nme.display.Sprite;

/**
 * The State class is very important. It usually contains the logic for a particular state the game is in.
 * There can only ever be one state running at a time. You should extend the State class
 * to create logic and scripts for your levels. You can build one state for each level, or
 * create a state that represents all your levels. You can get and set the reference to your active
 * state via the CitruxEngine class.
 */
class State<T> extends Sprite {

	public var view(getView, never):CitruxView;

	private var _ce:CitruxEngine<T>;

	private var _objects:Array<CitruxObject>;
	private var _view:CitruxView;
	private var _input:Input;

	public function new() {

		super();

		_ce = cast CitruxEngine.getInstance();

		_objects = new Array<CitruxObject>();
	}

	/**
	 * Called by the CitruxEngine.
	 */
	public function destroy():Void {

		var n:Int = _objects.length;
		while (n-- > 0) {

			var object:CitruxObject = _objects[n];
			object.destroy();
		}

		_objects = [];
		_view.destroy();
		_view = null;
		_input = null;
	}

	/**
	 * Gets a reference to this state's view manager. Take a look at the class definition for more information about this. 
	 */
	public function getView():CitruxView {
		return _view;
	}

	/**
	 * You'll most definitely want to override this method when you create your own State class. This is where you should
	 * add all your CitruxObjects and pretty much make everything. Please note that you can't successfully call add() on a 
	 * state in the constructur. You should call it in this initialize() method. 
	 */
	public function initialize():Void {
		
		_view = createView();
		_input = _ce.input;
	}

	/**
	 * This method calls update on all the CitruxObjects that are attached to this state.
	 * The update method also checks for CitruxObjects that are ready to be destroyed and kills them.
	 * Finally, this method updates the Input and View managers. 
	 */	
	public function update(timeDelta:Float):Void {

		//Call update on all objects
		var garbage:Array<CitruxObject> = [];
		var n:Int = _objects.length;

		for (i in 0...n) {

			var object:CitruxObject = _objects[i];
			if (object.kill == true)
				garbage.push(object);
			else
				object.update(timeDelta);
		}

		//Destroy all objects marked for destroy
		n = garbage.length;

		for (i in 0...n) {

			var garbageObject:CitruxObject = garbage[i];
			_objects.splice(Lambda.indexOf(_objects, garbageObject), 1);
			garbageObject.destroy();
			_view.removeArt(garbageObject);
		}

		//Update the input object
		_input.update();

		//Update the state's view
		_view.update();
	}

	/**
	 * Call this method to add a CitruxObject to this state. All visible game objects and physics objects
	 * will need to be created and added via this method so that they can be properly creatd, managed, updated, and destroyed. 
	 * @return The CitruxObject that you passed in. Useful for linking commands together.
	 */
	public function add(object:CitruxObject):CitruxObject {

		_objects.push(object);
		_view.addArt(object);
		return object;
	}

	/**
	 * When you are ready to remove an object from getting updated, viewed, and generally being existent, call this method.
	 * Alternatively, you can just set the object's kill property to true. That's all this method does at the moment. 
	 */
	public function remove(object:CitruxObject):Void {

		object.kill = true;
	}

	/**
	 * Gets a reference to a CitruxObject by passing that object's name in.
	 * Often the name property will be set via a level editor such as the Flash IDE.
	 * @param name The name property of the object you want to get a reference to.
	 */
	public function getObjectByName(name:String):CitruxObject {

		for (object in _objects) {
			if (object.name == name)
				return object;
		}

		return null;
	}

	/**
	 * Returns the first instance of a CitruxObject that is of the class that you pass in.
	 * This is useful if you know that there is only one object of a certain time in your state (such as a "Hero").
	 * @param type The class of the object you want to get a reference to.
	 */
	public function getFirstObjectByType(type:Class<Dynamic>):CitruxObject {

		for (object in _objects) {
			if (Std.is(object, type))
				return object;
		}

		return null;
	}

	/**
	 * This returns an array of all objects of a particular type. This is useful for adding an event handler
	 * to all similar objects. For instance, if you want to track the collection of coins, you can get all objects
	 * of type "Coin" via this method. Then you'd loop through the returned array to add your listener to the coins' event.
	 */
	public function getObjectsByType(type:Class<Dynamic>):Array<CitruxObject> {

		var objects:Array<CitruxObject> = new Array<CitruxObject>();
		for (object in _objects) {
			if (Std.is(object, type))
				objects.push(object);
		}

		return objects;
	}

	/**
	 * Override this method if you want a state to create an instance of a custom view. 
	 */		
	private function createView():CitruxView {
		return new SpriteView(this);
	}
}
