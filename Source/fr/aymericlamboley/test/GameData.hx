package fr.aymericlamboley.test;

import com.citruxengine.utils.AGameData;

class GameData extends AGameData {

	public var customProp:Int;

	public function new () {

		super();

		_lives = 5;
	}
}