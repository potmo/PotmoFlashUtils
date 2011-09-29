package
{
	import com.potmo.util.math.StrictMath;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;

	public class MathTester extends Sprite
	{
		public function MathTester()
		{
			var start:int = getTimer();
			trace("org: " + Math.sqrt(124123).toPrecision(21) );
			trace(getTimer()-start);
			start = getTimer();
			trace("new: " + StrictMath.sqrt(124123).toPrecision(21) );
			trace(getTimer()-start);
			
			start = getTimer();
			for (var i:uint = 0; i < 10000; i++)
			{
				Math.pow(124123,0.5);
			}
			trace("org: " + (getTimer()-start));
			start = getTimer();
			for (var j:uint = 0; j < 10000; j++)
			{
				StrictMath.pow(124123,0.5);
			}
			trace("new: " + (getTimer()-start));
		}
	}
}