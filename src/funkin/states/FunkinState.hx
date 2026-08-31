package funkin.states;

import funkin.backend.FlxAudioHandler;
import flixel.FlxState;

#if mobile
import flixel.group.FlxGroup;
import flixel.util.FlxDestroyUtil;
import funkin.mobile.controls.MobileHitbox;
import funkin.mobile.controls.MobileVirtualPad;
#end

class FunkinState extends FlxState {
	public static var menuSong:String = "";
	var skipMusicCheck:Bool = false;

	// using for mobile
	public static var instance:FunkinState;

	#if mobile
	public var hitbox:MobileHitbox;
	public var virtualPad:MobileVirtualPad;

	public var virtualPadCam:FlxCamera;
	public var hitboxCam:FlxCamera;

    public function addVirtualPad(DPad:MobileDPadMode, Action:MobileActionMode)
	{
		virtualPad = new MobileVirtualPad(DPad, Action);
		add(virtualPad);
	}
	
	public function addVirtualPadCamera(DefaultDrawTarget:Bool = false)
	{
		if (virtualPad != null)
		{
			virtualPadCam = new FlxCamera();
			virtualPadCam.bgColor.alpha = 0;
			FlxG.cameras.add(virtualPadCam, DefaultDrawTarget);
			
			virtualPad.cameras = [virtualPadCam];
		}
	}

	public function removeVirtualPad()
	{
		if (virtualPad != null)
		{
			remove(virtualPad);
			virtualPad = FlxDestroyUtil.destroy(virtualPad);
		}

		if(virtualPadCam != null)
		{
			FlxG.cameras.remove(virtualPadCam);
			virtualPadCam = FlxDestroyUtil.destroy(virtualPadCam);
		}
	}

	public function addMobileControls(DefaultDrawTarget:Bool = false)
	{
		hitbox = new MobileHitbox();

		hitboxCam = new FlxCamera();
		hitboxCam.bgColor.alpha = 0;
		FlxG.cameras.add(hitboxCam, DefaultDrawTarget);

		hitbox.cameras = [hitboxCam];
		hitbox.visible = false;
		add(hitbox);
	}

	public function removeMobileControls()
	{
		if (hitbox != null)
		{
			remove(hitbox);
			hitbox = FlxDestroyUtil.destroy(hitbox);
		}

		if(hitboxCam != null)
		{
			FlxG.cameras.remove(hitboxCam);
			hitboxCam = FlxDestroyUtil.destroy(hitboxCam);
		}
	}
	#end

	override function destroy()
	{
		super.destroy();

		#if mobile
		removeVirtualPad();
		removeMobileControls();
		#end
	}

	override function create() {
		super.create();
		instance = this;
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
