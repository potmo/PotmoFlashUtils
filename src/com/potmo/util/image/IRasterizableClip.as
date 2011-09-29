package com.potmo.util.image{
	import flash.display.DisplayObject;

	public interface IRasterizableClip{
		
		/** Steps to the next frame in the animation
		 * 
		 * @param frame the frame of the animation we step to
		 * @returns true if the animation should go one more frame and false otherwise
		 **/
		function stepFrame(frame:int):Boolean;
		
		function getGraphics():DisplayObject;
	}
}