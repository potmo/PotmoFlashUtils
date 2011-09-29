package com.potmo.util.spline.qubicHermite{
	import flash.geom.Point;

	/**
	 * @author nissebergman
	 */
	public class Spline {
		
		public static function cubicHermiteSpline(n:uint, p0:Point, p1:Point, h0:Point, h1:Point):Vector.<Point>
		{
			var out:Vector.<Point> = new Vector.<Point>();
			var px:Number;
			var py:Number;
			var t:Number = 0;			
			for (var i:Number = 0; i < n; i++){
				
				t += 1.0 / n;
				
		        var t_2:Number = t * t;
		        var t_3:Number = t_2 * t;
		       
		        // some repetitive math for clarity
		        px = (2 * t_3  - 3 * t_2 + 1) * p0.x +(t_3 - 2 * t_2 + t) * h0.x + (-2 * t_3 + 3 * t_2) * p1.x + (t_3 - t_2) * h1.x;
		        py = (2 * t_3  - 3 * t_2 + 1) * p0.y +(t_3 - 2 * t_2 + t) * h0.y + (-2 * t_3 + 3 * t_2) * p1.y + (t_3 - t_2) * h1.y;
		                 
		        out.push(new Point(px,py));

		    }
		    
		    return out;	
		}
		
		public static function cubicHermiteSplineFromNPoints(parts : Vector.<SplinePart>):Vector.<Point>
		{
			var out:Vector.<Point> = new Vector.<Point>();
			var spline:Vector.<Point>;
			for (var i:int = 0; i < parts.length-1; i++)
			{
				spline = cubicHermiteSpline(parts[i].stepsToNext, parts[i].point, parts[i+1].point, parts[i].handler, parts[i + 1].handler);
				for each(var p:Point in spline)
				{
					out.push(p);
				}	
			}
			return out;
		}
		
	}
	
	
}
