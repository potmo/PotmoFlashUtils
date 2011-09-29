package com.potmo.util.image{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.ShaderPrecision;
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ImageCompare{
		
		[Embed(source="../../../../../assets/pixelBender/image/compareImages.pbj", mimeType="application/octet-stream")]
		private static const PB_CLASS_COMPARE_IMAGES:Class;
		private static const PB_SHADER_COMPARE_IMAGES:Shader = new Shader(new PB_CLASS_COMPARE_IMAGES());
		
		public static function compareImages(img0:BitmapData, img1:BitmapData):Number
		{
			var result:ByteArray;
			var shader:Shader = PB_SHADER_COMPARE_IMAGES;
			var shaderJob:ShaderJob;
			
			shader.data.src0.input = img0;
			shader.data.src1.input = img1;
			shader.precisionHint = ShaderPrecision.FULL;
			
			result = new ByteArray();
			result.endian = Endian.LITTLE_ENDIAN;
			
			shaderJob = new ShaderJob(shader, result, img0.width, img0.height);
			shaderJob.start(true);
			
			return getFloat(result);
			
		}
		
		private static function getFloat(result:ByteArray):Number
		{
			result.position = 0;
			var number:Number = 0;
			var resultFloat:Number = 0;
			var i:uint;
			var length:uint = result.length;
			for(i = 0; i<length; i+=4)
			{
				number = result.readFloat();
				
				if(i % 3 == 0)
				{
					resultFloat += number;
				}
			}
			
			return resultFloat;
			
		}
		
		
		
	}
}