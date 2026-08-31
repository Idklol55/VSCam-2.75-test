package funkin.states;

import funkin.backend.FlxAudioHandler;
import flixel.FlxState;

class FunkinState extends FlxState {
	public static var menuSong:String = "";
	var skipMusicCheck:Bool = false;

	#if mobile
	public var touchPad:TouchPad;
	public var touchPadCam:FlxCamera;
	public var luaTouchPad:TouchPad;
	public var luaTouchPadCam:FlxCamera;
	public var mobileControls:IMobileControls;
	public var mobileControlsCam:FlxCamera;

	public function addTouchPad(DPad:String, Action:String)
	{
		touchPad = new TouchPad(DPad, Action);
		add(touchPad);
	}

	public function removeTouchPad()
	{
		if (touchPad != null)
		{
			remove(touchPad);
			touchPad = FlxDestroyUtil.destroy(touchPad);
		}

		if (touchPadCam != null)
		{
			FlxG.cameras.remove(touchPadCam);
			touchPadCam = FlxDestroyUtil.destroy(touchPadCam);
		}
	}

	public function addMobileControls(defaultDrawTarget:Bool = false):Void
	{
		var extraMode = MobileData.extraActions.get(ClientPrefs.data.extraButtons);

		switch (MobileData.mode)
		{
			case 0: // RIGHT_FULL
				mobileControls = new TouchPad('RIGHT_FULL', 'NONE', extraMode);
			case 1: // LEFT_FULL
				mobileControls = new TouchPad('LEFT_FULL', 'NONE', extraMode);
			case 2: // CUSTOM
				mobileControls = MobileData.getTouchPadCustom(new TouchPad('RIGHT_FULL', 'NONE', extraMode));
			case 3: // HITBOX
				mobileControls = new Hitbox(extraMode);
		}

		mobileControls.instance = MobileData.setButtonsColors(mobileControls.instance);
		mobileControlsCam = new FlxCamera();
		mobileControlsCam.bgColor.alpha = 0;
		FlxG.cameras.add(mobileControlsCam, defaultDrawTarget);

		mobileControls.instance.cameras = [mobileControlsCam];
		mobileControls.instance.visible = false;
		add(mobileControls.instance);
	}

	public function removeMobileControls()
	{
		if (mobileControls != null)
		{
			remove(mobileControls.instance);
			mobileControls.instance = FlxDestroyUtil.destroy(mobileControls.instance);
			mobileControls = null;
		}

		if (mobileControlsCam != null)
		{
			FlxG.cameras.remove(mobileControlsCam);
			mobileControlsCam = FlxDestroyUtil.destroy(mobileControlsCam);
		}
	}

	public function addTouchPadCamera(defaultDrawTarget:Bool = false):Void
	{
		if (touchPad != null)
		{
			touchPadCam = new FlxCamera();
			touchPadCam.bgColor.alpha = 0;
			FlxG.cameras.add(touchPadCam, defaultDrawTarget);
			touchPad.cameras = [touchPadCam];
		}
	}
/*
	public function makeLuaTouchPad(DPadMode:String, ActionMode:String)
	{
		if (members.contains(luaTouchPad))
			return;

		if (!variables.exists("luaTouchPad"))
			variables.set("luaTouchPad", luaTouchPad);

		luaTouchPad = new TouchPad(DPadMode, ActionMode, NONE);
		luaTouchPad.alpha = ClientPrefs.data.controlsAlpha;
	}

	public function addLuaTouchPad()
	{
		if (luaTouchPad == null || members.contains(luaTouchPad))
			return;

		var target = LuaUtils.getTargetInstance();
		target.insert(target.members.length + 1, luaTouchPad);
	}

	public function addLuaTouchPadCamera(defaultDrawTarget:Bool = false)
	{
		if (luaTouchPad != null)
		{
			luaTouchPadCam = new FlxCamera();
			luaTouchPadCam.bgColor.alpha = 0;
			FlxG.cameras.add(luaTouchPadCam, defaultDrawTarget);
			luaTouchPad.cameras = [luaTouchPadCam];
		}
	}

	public function removeLuaTouchPad()
	{
		if (luaTouchPad != null)
		{
			luaTouchPad.kill();
			luaTouchPad.destroy();
			remove(luaTouchPad);
			luaTouchPad = null;
		}
	}

	public function luaTouchPadPressed(button:Dynamic):Bool
	{
		if (luaTouchPad != null)
		{
			if (Std.isOfType(button, String))
				return luaTouchPad.buttonPressed(MobileInputID.fromString(button));
			else if (Std.isOfType(button, Array))
			{
				var FUCK:Array<String> = button; // haxe said "You Can't Iterate On A Dyanmic Value Please Specificy Iterator or Iterable *insert nerd emoji*" so that's the only i found to fix
				var idArray:Array<MobileInputID> = [];
				for (strId in FUCK)
					idArray.push(MobileInputID.fromString(strId));
				return luaTouchPad.anyPressed(idArray);
			}
			else
				return false;
		}
		return false;
	}

	public function luaTouchPadJustPressed(button:Dynamic):Bool
	{
		if (luaTouchPad != null)
		{
			if (Std.isOfType(button, String))
				return luaTouchPad.buttonJustPressed(MobileInputID.fromString(button));
			else if (Std.isOfType(button, Array))
			{
				var FUCK:Array<String> = button;
				var idArray:Array<MobileInputID> = [];
				for (strId in FUCK)
					idArray.push(MobileInputID.fromString(strId));
				return luaTouchPad.anyJustPressed(idArray);
			}
			else
				return false;
		}
		return false;
	}

	public function luaTouchPadJustReleased(button:Dynamic):Bool
	{
		if (luaTouchPad != null)
		{
			if (Std.isOfType(button, String))
				return luaTouchPad.buttonJustReleased(MobileInputID.fromString(button));
			else if (Std.isOfType(button, Array))
			{
				var FUCK:Array<String> = button;
				var idArray:Array<MobileInputID> = [];
				for (strId in FUCK)
					idArray.push(MobileInputID.fromString(strId));
				return luaTouchPad.anyJustReleased(idArray);
			}
			else
				return false;
		}
		return false;
	}

	public function luaTouchPadReleased(button:Dynamic):Bool
	{
		if (luaTouchPad != null)
		{
			if (Std.isOfType(button, String))
				return luaTouchPad.buttonJustReleased(MobileInputID.fromString(button));
			else if (Std.isOfType(button, Array))
			{
				var FUCK:Array<String> = button;
				var idArray:Array<MobileInputID> = [];
				for (strId in FUCK)
					idArray.push(MobileInputID.fromString(strId));
				return luaTouchPad.anyReleased(idArray);
			}
			else
				return false;
		}
		return false;
	}
*/
	#end

	override function destroy()
	{
		#if mobile
		removeTouchPad();
		// removeLuaTouchPad();
		removeMobileControls();
		#end

		super.destroy();
	}

	override function create() {
		super.create();
		//Conductor.reset();
		Paths.clearUnusedMemory();

		Conductor.onStep.add(stepHit);
		Conductor.onBeat.add(beatHit);
		Conductor.onMeasure.add(measureHit);

		musicCheck();
	}
	
	function musicCheck() {
		if (skipMusicCheck || FlxAudioHandler.music.playing) return;

		funkin.backend.CreditsStuff.MenuMusic.loadMusicList();
		menuSong = funkin.backend.CreditsStuff.MenuMusic.gimmeMusicName();
		funkin.backend.CreditsStuff.MenuMusic.menuCredits(this);
		Conductor.inst = FlxAudioHandler.loadMusic(Paths.audioPath(menuSong, 'music'), true);
		Conductor.play();

		if (!funkin.backend.CreditsStuff.MenuMusic.gameInitialized)
			funkin.backend.CreditsStuff.MenuMusic.gameInitialized = true;
	}

	public function stepHit(step:Int):Void {}

	public function beatHit(beat:Int):Void {}
	public function measureHit(measure:Int):Void {}
}
