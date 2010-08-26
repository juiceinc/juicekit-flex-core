package org.juicekit.util {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	
	import mx.events.FlexEvent;
	
	import org.juicekit.util.Maths;
	import org.juicekit.util.Strings;
	
	import spark.components.Label;
	
	/**
	 * A Label that provides statistics about how fast
	 * an animation is running. 
	 * 
	 */
	public class FPSLabel extends Label {
		private var startTime:uint = getTimer();
		private var lastTime:uint = getTimer();
		private var ticks:uint = 0;
		private var running:Boolean = false;
		
		private function colorLookup(duration:int):uint {
			var fps:Number = 1000 / duration;
			
			if (fps > 22) {
				return 0x006737;
			} else if (fps > 20) {
				return 0x229c52;
			} else if (fps > 18) {
				return 0x74c364;
			} else if (fps > 15) {
				return 0xb7e075;			
			} else if (fps > 12) {
				return 0xe9f6a2;
			} else if (fps > 10) {
				return 0xfeeda2;
			} else if (fps > 7) { 
				return 0xfdbe6f;
			} else if (fps > 4) {
				return 0xf67b49;
			} else if (fps > 2.5) {
				return 0xda362a;
			} else {
				return 0xa50025;
			}
		}
		
		private var data:Array = [];
		
		
		/**
		 * Should a sparkline be displayed below the timer showing
		 * the performance of each frame.
		 */
		public var showSparkline:Boolean = true;
		
		/**
		 * The maximum amount of time the label should monitor for 
		 * in milliseconds.
		 */
		public var stopAtDuration:Number = 5000;
		
		
		/**
		 * Constructor
		 */
		public function FPSLabel():void {
			text = "----- fps";
			this.addEventListener(Event.ADDED_TO_STAGE, function():void {
				addEventListener(Event.ENTER_FRAME, tick);				
			});
		}
		
		
		/**
		 * Start timing performance
		 */
		public function start():void {			
			startTime = getTimer();
			lastTime = getTimer();
			ticks = 0;
			_x = 0;
			data = [];
			running = true;
		}
		
		
		/**
		 * Stom timing performance
		 */
		public function stop():void {
			running = false;
		}
		
		
		private var _x:Number = 0;
		
		/**
		 * Draw a sparkline under the label to indicate the performance of each tick.
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if (showSparkline) {
				var x:int = 0;
				var w:int = 2;
				var c:uint;
				var n:int;

				if (_x == 0) graphics.clear();

				if (data.length > 0) {
					n = data[data.length -1];
					c = colorLookup(n);
					w = 2 * (n/40);
					w = Maths.clampValue(int(w), 2, 48);
					graphics.beginFill(c, 1);
					graphics.drawRect(_x,12,w,6);
					_x += (w+1);
				}
			}
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		
		/**
		 * Capture performance statistics when a frame is rendered.
		 */
		protected function tick(evt:Event):void {
			if (running) {
				ticks++;
				var now:uint = getTimer();
				var delta:uint = now - startTime;
				var fps:Number = ticks / (delta / 1000);
				data.push(now-lastTime);
				lastTime = getTimer();
				text = Strings.format("{0:0.0} fps, {1} frames, {2}ms", fps, ticks, delta);
				
				if ((lastTime - startTime) > stopAtDuration) {
					stop();
				}
			}
		}
	}
}