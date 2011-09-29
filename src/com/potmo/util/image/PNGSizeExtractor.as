package com.potmo.util.image{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class PNGSizeExtractor extends URLStream{
		
		/*
		========================================================
		| Private Variables                         | Data Type  
		========================================================
		*/		
		
		private var byteHolder:						ByteArray = new ByteArray();		
		private var metaHolder:						Array = new Array();				
		
		/*
		========================================================
		| Public Constants                          | Data Type  
		========================================================
		*/		
		
		public static const PARSE_COMPLETE:			String = "parseComplete";
		public static const PARSE_FAILED:			String = "parseFailed";
		
		/*
		========================================================
		| Constructor
		========================================================
		*/
		
		public function PNGMetaExtractor():void{
			endian = Endian.BIG_ENDIAN;
		}
		
		/*
		========================================================
		| Private methods
		========================================================
		*/
		
		public static function checkFileExtension(fileURL:String):Boolean{
			var fileExtension:String = fileURL.substr((fileURL.length - 3), fileURL.length);
			if(fileExtension == "png"){return true;}else{return false;}
		}
		
		/*
		========================================================
		| Public methods
		========================================================
		*/		
		
		public function extractSize(fileURL:String):void{			
			if(checkFileExtension(fileURL) == true){
				addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);						
				addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);									
				super.load(new URLRequest(fileURL));												
			}else{
				dispatchEvent(new Event(PARSE_FAILED));
			}
		}		
		
		/*
		========================================================
		| Event handlers
		========================================================
		*/
		
		private function progressHandler(event:ProgressEvent):void{		
			readBytes(byteHolder, 0); 		
			byteHolder.position = 10;
			if(byteHolder.readUTF() == "IHDR"){
				byteHolder.position = 16;
				metaHolder['width'] = byteHolder.readUnsignedInt();				
				byteHolder.position = 20;
				metaHolder['height'] = byteHolder.readUnsignedInt();
				metaHolder['size'] = event.bytesTotal;
				removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				super.close();
				dispatchEvent(new Event(PARSE_COMPLETE));				
			}else{
				removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				super.close();
				dispatchEvent(new Event(PARSE_FAILED));				
			}
		}		
		
		private function errorHandler(event:IOErrorEvent):void{
			dispatchEvent(new Event(PARSE_FAILED));			
		}
		
		/*
		========================================================
		| Getters + Setters
		========================================================
		*/
		
		public function get availableData():Array{
			return metaHolder;
		}
		
		public function get height():int{
			return this.availableData['height'];
		}
		
		public function get width():int{
			return this.availableData['width'];
		}
	}
}