package fr.aymericlamboley.test;

import com.citruxengine.core.CitruxEngine;
import com.citruxengine.core.State;
import com.citruxengine.objects.PhysicsObject;
import com.citruxengine.objects.platformer.Baddy;
import com.citruxengine.objects.platformer.Hero;
import com.citruxengine.objects.platformer.MovingPlatform;
import com.citruxengine.objects.platformer.Platform;
import com.citruxengine.objects.platformer.Sensor;
import com.citruxengine.physics.Box2D;
import com.citruxengine.utils.MathVector;

import nme.geom.Rectangle;

class GameState extends State {

	public function new() {

		super();
	}

	override public function initialize():Void {

		super.initialize();

		var box2d:Box2D = new Box2D("Box2D");
		box2d.visible = true;
		add(box2d);

		var citruxObject:PhysicsObject = new PhysicsObject("monCitruxObject", {x:250, y:200, width:30, height:30});
		//var citruxObject:PhysicsObject = new PhysicsObject("monCitruxObject", {x:100, y:20});
		//var citruxObject:PhysicsObject = new PhysicsObject("monCitruxObject", {x:100, y:20, radius:20});
		add(citruxObject);

		var baddy:Baddy = new Baddy("baddy", {x:340, y:200, width:30, height:60});
		add(baddy);

		var sensor:Sensor = new Sensor("sensor", {x:400, y:420, width:20, height:20});
		add(sensor);

		var movingPlatform:MovingPlatform = new MovingPlatform("movingPlatform", {x:430, y:120, width:50, height:20, endX:430, startY:20, endY:300});
		add(movingPlatform);

		var platformBot:Platform = new Platform("platformBot", {x:260, y:450, width:500, height:30});
		add(platformBot);

		var hero:Hero = new Hero("hero", {x:100, y:20, width:30, height:60});
		add(hero);

		view.setupCamera(hero, new MathVector(320, 240), new Rectangle(0, 0, 1550, 450), new MathVector(.25, .05));
	}
}