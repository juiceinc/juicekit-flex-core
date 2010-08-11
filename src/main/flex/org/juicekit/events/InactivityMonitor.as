/*
* Copyright 2007-2010 Juice, Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


package org.juicekit.events {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Dispatched when the idle period has expired with no activity.
	 *
	 * @eventType org.juicekit.events.InactivityEvent.JK_INACTIVITY_PERIOD
	 */
	[Event(name="jkInactivityPeriod", type="org.juicekit.events.InactivityEvent")]
	
	
	/**
	 * Monitors other event dispatchers for keyboard or mouse events in order to 
	 * signal periods of inactivity to listeners.
	 *
	 * @author Jon Buffington
	 * @author Chris Gemignani
	 *
	 * @see InactivityEvent
	 */
	public class InactivityMonitor extends EventDispatcher {
		
		
		/** @private */
		protected var _timer:Timer;
		/** @private */
		protected var _monitored:IEventDispatcher;
		/** @private */
		protected var _monitoredEvents:Array = [MouseEvent.CLICK, KeyboardEvent.KEY_DOWN, KeyboardEvent.KEY_UP];
		
		
		/**
		 * Constructor.
		 *
		 * @param monitored References an IEventDispatcher to be watched for
		 * periods of inactivity.
		 *
		 * @param maxIdle Specifies the minimum number of milliseconds between
		 * watched events before an InactivityEvent is dispatched.
		 */
		public function InactivityMonitor(monitored:IEventDispatcher = null,
										  maxIdle:Number = 5000) {
			super();
			_timer = new Timer(maxIdle);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			
			this.monitor = monitored;
		}
		
		
		/**
		 * Specifies the minimum number of milliseconds between
		 * watched events before an InactivityEvent is dispatched.
		 */
		public function set duration(value:Number):void {
			_timer.delay = value;
		}
		
		public function get duration():Number {
			return _timer.delay;
		}
		
		
		/**
		 * Specifies the event names to monitor. The default
		 * monitored events are MouseEvent.CLICK, KeyboardEvent.KEY_DOWN,
		 * and KeyboardEvent.KEY_UP.
		 * 
		 * @param eventArray an Array of Event names to monitor.
		 */
		public function setMonitoredEvents(eventArray:Array):void {
			shutdown();
			_monitoredEvents = eventArray.slice();
			boot();
		}
		
		
		/**
		 * Restarts the idle-period counter from zero.
		 */
		public function restart():void {
			if (_monitored) {
				if (_timer.running) {
					// Reset the counter and unfortunately stop the timer.
					_timer.reset();
				}
				// Start/restart the timer.
				_timer.start();
			}
		}
		
		private function handleTimer(event:TimerEvent):void {
			_timer.reset();	// stop and zero the internal counter
			dispatchEvent(new InactivityEvent(InactivityEvent.JK_INACTIVITY_PERIOD,
				false,
				false,
				_monitored,
				_timer.delay));
		}
		
		private function handleActivity(event:Event):void {
			restart();
		}
		
		
		/**
		 * @private
		 */
		private function boot():void {
			var e:Object;
			if (_monitored) {
				_timer.reset();	// stop and zero the internal counter
				for each (e in _monitoredEvents) {
					_monitored.addEventListener(String(e), handleActivity);
				}
				_timer.start();
			}
		}
		
		/**
		 * @private
		 */
		private function shutdown():void {
			var e:Object;
			if (_monitored) {
				_timer.reset();	// stop and zero the internal counter
				for each (e in _monitoredEvents) {
					_monitored.removeEventListener(String(e), handleActivity);
				}
			}
		}
		
		
		
		/**
		 * References an IEventDispatcher to be watched for periods of inactivity.
		 */
		public function get monitor():IEventDispatcher {
			return _monitored;
		}
		
		public function set monitor(monitored:IEventDispatcher):void {
			shutdown();
			_monitored = monitored;
			boot();
		}
	}
}
