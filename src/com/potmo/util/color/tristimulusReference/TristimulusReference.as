package com.potmo.util.color.tristimulusReference{
	import flash.errors.IllegalOperationError;

	public class TristimulusReference{
		
	
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function TristimulusReference(x:Number, y:Number, z:Number)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public static function getTristimulus(observer:Observer, illuminant:Illuminant):TristimulusReference
		{
			switch (observer)
			{
				case Observer.CIE1931: return getCIE1931Reference(illuminant);
				case Observer.CIE1964: return getCIE1964Reference(illuminant);
				default: throw new IllegalOperationError("bad observer value");
			}
		}
		
		private static function getCIE1931Reference(illuminant:Illuminant):TristimulusReference
		{

			switch (illuminant)
			{
				case Illuminant.A: return new TristimulusReference(109.850, 100.0, 35.585);
				case Illuminant.C: return new TristimulusReference(98.074, 100, 118.232);
				case Illuminant.D50: return new TristimulusReference(96.422,100,82.521);
				case Illuminant.D55: return new TristimulusReference(95.682,100,92.149);
				case Illuminant.D65: return new TristimulusReference(95.047,100,108.883);
				case Illuminant.D75: return new TristimulusReference(94.972,100,122.638);
				case Illuminant.F2: return new TristimulusReference(99.187,100,67.395);
				case Illuminant.F7: return new TristimulusReference(95.044,100,108.755);
				case Illuminant.F11: return new TristimulusReference(100.966,100,64.370);
					
				default: throw new IllegalOperationError("bad illuminant value");
			}
		}
		
		private static function getCIE1964Reference(illuminant:Illuminant):TristimulusReference
		{
			switch (illuminant)
			{
				case Illuminant.A: return new TristimulusReference(111.144,100,35.200);
				case Illuminant.C: return new TristimulusReference(97.285,100,116.145);
				case Illuminant.D50: return new TristimulusReference(96.720,100,81.427);
				case Illuminant.D55: return new TristimulusReference(95.799,100,90.926);
				case Illuminant.D65: return new TristimulusReference(94.811,100,107.304);
				case Illuminant.D75: return new TristimulusReference( 94.416,100,120.641);
				case Illuminant.F2: return new TristimulusReference(103.280,100,69.026);
				case Illuminant.F7: return new TristimulusReference(95.792,100,107.687);
				case Illuminant.F11: return new TristimulusReference(103.866,100,65.627);
					
				default: throw new IllegalOperationError("bad illuminant value");
			}
		}
	}
}
