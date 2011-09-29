/**
 * Copyright 2009 (c) , Brooks Andrus
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 */
package com.potmo.util.image.resampling
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	
	public class Resampler
	{
		[Embed ( source="/com/potmo/util/image/resampling/pixelBender/bilinearresample.pbj", mimeType="application/octet-stream" ) ]
		private static const BilinearScaling:Class;
		
		[Embed ( source="/com/potmo/util/image/resampling/pixelBender/bicubicResampling.pbj", mimeType="application/octet-stream" ) ]
		private static const BicubicScaling:Class;
		
		
		public static function resampleBitmapBilinear( input:BitmapData, desiredWidth:int, desiredHeight:int, cleanup:Boolean = true ):BitmapData
		{
			var aspectRatio:Number = input.width / input.height;
			
			var factor:Number = Math.max( input.width / desiredWidth, input.height / desiredHeight );
			
			// create and configure a Shader object
			var shader:Shader = new Shader();
			shader.byteCode = new BilinearScaling(); // instantiate embedded Pixel Bender bytecode
			shader.data.src.input = input; // supply the shader with BitmapData it will manipulate
			shader.data.scale.value = [factor]; // scale factor. shader params are all stored in arrays.
			
			var outputWidth:int;
			var outputHeight:int;
			
			// determine output bitmap dimensions
			if ( input.width > input.height )
			{
				outputWidth = desiredWidth;
				outputHeight = desiredWidth / aspectRatio;
			}
			else
			{
				outputWidth = desiredHeight * aspectRatio;
				outputHeight = desiredHeight;
			}
			
			// create a bitmap - our shader will return its data (an image) to this bitmap
			var output:BitmapData = new BitmapData( outputWidth, outputHeight );
			
			// shader jobs are wicked cool
			var job:ShaderJob = new ShaderJob();
			job.target = output; // ShaderJob returns to this object
			job.shader = shader; // The Shader assigned to this job
			job.start( true ); // true flag runs the job synchronously.
			
			if ( cleanup )
			{
				input.dispose();
			}
			
			return output;
		}
		
		public static function resampleDisplayObjectBilinear( source:DisplayObject, output:BitmapData, desiredWidth:int, desiredHeight:int ):BitmapData
		{
			var aspectRatio:Number = source.width / source.height;
			
			var factor:Number = Math.max( source.width / desiredWidth, source.height / desiredHeight );
			
			var input:BitmapData = new BitmapData( source.width, source.height, true );
			input.draw( source );
			
			// configure the shader
			var shader:Shader = new Shader();
			shader.byteCode = new BilinearScaling();
			shader.data.src.input = input;
			shader.data.scale.value = [factor]; // scale factor. shader params are all stored in arrays.
			
			var outputWidth:int;
			var outputHeight:int;
			
			if ( input.width > input.height )
			{
				outputWidth = desiredWidth;
				outputHeight = desiredWidth / aspectRatio;
			}
			else
			{
				outputWidth = desiredHeight * aspectRatio;
				outputHeight = desiredHeight;
			}
			
			//var output:BitmapData = new BitmapData( outputWidth, outputHeight );
			
			var job:ShaderJob = new ShaderJob();
			job.target = output;
			job.shader = shader;
			job.start( true ); // true flag runs the job synchronously.
			
			input.dispose();
			
			return output;
		}
		
		public static function resampleDisplayObjectBicubic( source:DisplayObject, destination:BitmapData,  desiredWidth:int, desiredHeight:int ):void
		{
			var aspectRatio:Number = source.width / source.height;
			
			var factor:Number = Math.max( source.width / desiredWidth, source.height / desiredHeight );
			
			var input:BitmapData = new BitmapData( source.width, source.height, true );
			input.draw( source );
			
			// configure the shader
			var shader:Shader = new Shader();
			//shader.byteCode = new BilinearScaling();
			shader.byteCode = new BicubicScaling();
			shader.data.src.input = input;
			//shader.data.scale.value = [factor]; // scale factor. shader params are all stored in arrays.
			shader.data.scale.value = [factor, factor]; // scale factor. shader params are all stored in arrays.
			
			var outputWidth:int;
			var outputHeight:int;
			
			if ( input.width > input.height )
			{
				outputWidth = desiredWidth;
				outputHeight = desiredWidth / aspectRatio;
			}
			else
			{
				outputWidth = desiredHeight * aspectRatio;
				outputHeight = desiredHeight;
			}
			
			
			var job:ShaderJob = new ShaderJob();
			job.target = destination;
			job.shader = shader;
			job.start( true ); // true flag runs the job synchronously.
			
			input.dispose();
			
			return void;
		}
	}
}