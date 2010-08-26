/*
* Copyright (c) 2007-2010 Regents of the University of California.
*   All rights reserved.
*
*   Redistribution and use in source and binary forms, with or without
*   modification, are permitted provided that the following conditions
*   are met:
*
*   1. Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the distribution.
*
*   3.  Neither the name of the University nor the names of its contributors
*   may be used to endorse or promote products derived from this software
*   without specific prior written permission.
*
*   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
*   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*   ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
*   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
*   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
*   OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
*   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
*   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
*   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
*   SUCH DAMAGE.
*/

package org.juicekit.util
{
	import flash.events.EventDispatcher;
	
	
	
	
	
	/**
	 * Utility class for computing statistics for a collection of values.
	 */
	[Bindable]
	public class Stats extends EventDispatcher
	{
		/** Constant indicating numerical values. */
		public static const NUMBER:int = 0;
		/** Constant indicating date/time values. */
		public static const DATE:int = 1;
		/** Constant indicating arbitrary object values. */
		public static const OBJECT:int = 2;
		
		private var _type:int = -1;
		private var _comp:Function = null;
		
		private var _num:Number = 0;
		private var _distinct:Number = 0;
		private var _elm:Array = null;
		
		private var _minObject:Object = null;
		private var _maxObject:Object = null;
		
		private var _min:Number = Number.MAX_VALUE;
		private var _max:Number = Number.MIN_VALUE;
		private var _percentileHigh:Number = Number.MAX_VALUE;
		private var _percentileLow:Number = Number.MIN_VALUE;
		private var _sum:Number = 0;
		private var _stdev:Number = 0;
		
		/** The data type of the collection, one of NUMBER, DATE, or OBJECT. */
		public function get dataType():int {
			return _type;
		}
		
		/** A sorted array of all the values. */
		public function get values():Array {
			return _elm;
		}
		
		/** A sorted array of all unique values in the collection. */
		public function get distinctValues():Array {
			// get array with only unique items
			var dists:Array = [];
			if (_elm == null || _elm.length == 0) return dists;
			dists.push(_elm[0]);
			for (var i:int = 1, j:int = 0; i < _num; ++i) {
				if (!equal(_elm[i], dists[j])) {
					dists.push(_elm[i]);
					++j;
				}
			}
			return dists;
		}
		
		/** The minimum value (for numerical data). */
		public function get minimum():Number {
			return _min;
		}
		
		/** The maximum value (for numerical data). */
		public function get maximum():Number {
			return _max;
		}
		
		/** The 0.025 percentile value (for numerical data). */
		public function get percentileLow():Number {
			return _percentileLow;
		}
		
		/** The 0.975 percentile value (for numerical data). */
		public function get percentileHigh():Number {
			return _percentileHigh;
		}
		
		/** The sum of all the values (for numerical data). */
		public function get sum():Number {
			return _sum;
		}
		
		/** The average of all the values (for numerical data). */
		public function get average():Number {
			return _sum / _num;
		}
		
		/** The standard deviation of all the values (for numerical data). */
		public function get stddev():Number {
			return _stdev;
		}
		
		/** The standard error of all the values (for numerical data). */
		public function get stderr():Number {
			return stddev / Math.sqrt(_num);
		}
		
		/** The total number of values. */
		public function get count():Number {
			return _num;
		}
		
		/** The total number of distinct values. */
		public function get distinct():Number {
			return _distinct;
		}

		/** 
		 * Get a percentile value
		 * 
		 * @param p a percentile between 0 and 1
		 * @return a percentile value for the input p. If the percentile falls between two values, a weighted average will be returned.
		 */
		public function getPercentile(p:Number):Number {
			p = Maths.clampValue(p, 0, 1);
			const N:int = _num - 1;
			const pval:Number = p * N;
			
			if (pval == Math.floor(pval)) {
				return _elm[pval];	
			} else {
				return (pval - Math.floor(pval)) * _elm[Math.ceil(pval) as int] + (Math.ceil(pval) - pval) * _elm[Math.floor(pval) as int];
			}
		}

		/** Get the 1st percentile value */
		public function get percentile1():Number { return getPercentile(0.01); }
		/** Get the 5th percentile value */
		public function get percentile5():Number { return getPercentile(0.05); }
		/** Get the 10th percentile value */
		public function get percentile10():Number { return getPercentile(0.10); }
		/** Get the 20th percentile value */
		public function get percentile20():Number { return getPercentile(0.20); }
		/** Get the 25th percentile value */
		public function get percentile25():Number { return getPercentile(0.25); }
		/** Get the 40th percentile value */
		public function get percentile40():Number { return getPercentile(0.40); }
		/** Get the 50th percentile value */
		public function get percentile50():Number { return getPercentile(0.50); }
		/** Get the 50th percentile value */
		public function get median():Number { return getPercentile(0.50); }
		/** Get the 60th percentile value */
		public function get percentile60():Number { return getPercentile(0.60); }
		/** Get the 750th percentile value */
		public function get percentile75():Number { return getPercentile(0.75); }
		/** Get the 80th percentile value */
		public function get percentile80():Number { return getPercentile(0.80); }
		/** Get the 90th percentile value */
		public function get percentile90():Number { return getPercentile(0.90); }
		/** Get the 95th percentile value */
		public function get percentile95():Number { return getPercentile(0.95); }
		/** Get the 99th percentile value */
		public function get percentile99():Number { return getPercentile(0.99); }

		
		/** The minimum value (for date/time values). */
		public function get minDate():Date {
			return _minObject as Date;
		}
		
		/** The maximum value (for date/time values). */
		public function get maxDate():Date {
			return _maxObject as Date;
		}
		
		/** The minimum value (for arbitrary objects). */
		public function get minObject():Object {
			return _minObject;
		}
		
		/** The maximum value (for arbitrary objects). */
		public function get maxObject():Object {
			return _maxObject;
		}
		
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new Stats instance using the given input data. If the
		 * field argument is null, it is assumed that the input data array
		 * directly contains the values to analyze. If the field argument is
		 * non-null, values will be extracted from the objects in the input
		 * array using the specified property name.
		 * @param data an input data array. The data to analyze may be
		 *  contained directly in the array, or may be properties of the
		 *  objects contained in the array.
		 * @param field a property name. This property will be used to extract
		 *  data values from the objects in the data array. If null, the
		 *  objects in the data array will be used directly.
		 * @param comparator the comparator function to use to sort the data.
		 *  If null, the natural sort order will be used.
		 * @param copy flag indicating if the input data array should be
		 *  copied to a new array. This flag only applied when the field
		 *  argument is null. In false, the input data array will be sorted.
		 *  If true, the array will be copied before being sorted. The default
		 *  behavior is to make a copy.
		 */
		public function Stats(data:Array, field:String = null,
							  comparator:Function = null, copy:Boolean = true)
		{
			_comp = comparator;
			init(data, field, copy);
		}
		
		private function init(data:Array, field:String, copy:Boolean):void
		{
			// INVARIANT: properties must be set to default values
			// TODO: how to handle null values?
			
			// collect all values into element array
			_num = data.length;
			if (_num == 0) return;
			_elm = (field == null ? (copy ? Arrays.copy(data) : data)
				: new Array(_num));
			if (field != null) {
				var p:Property = Property.$(field);
				for (var i:uint = 0; i < _num; ++i) {
					_elm[i] = p.getValue(data[i]);
				}
			}
			
			// determine data type
			for (i = 0; i < _num; ++i) {
				var v:Object = _elm[i], type:int;
				type = v is Date ? DATE : (v is Number ? NUMBER : OBJECT);
				
				if (_type == -1) {
					_type = type; // seed type
				} else if (type != _type) {
					_type = OBJECT; // punt if no match
					break;
				}
			}
			
			// sort data values
			var opt:int = (_type == OBJECT ? 0 : Array.NUMERIC);
			if (_comp == null) _elm.sort(opt); else _elm.sort(_comp, opt);
			
			// count unique values
			_distinct = 1;
			var j:uint = 0;
			for (i = 1; i < _num; ++i) {
				if (!equal(_elm[i], _elm[j])) {
					++_distinct;
					j = i;
				}
			}
			
			// populate stats
			var N:int = _num - 1;
			if (_type == NUMBER)
			{
				
				//Calculate the 2.5th and the 97.5th percentile of the data
				_percentileLow = this.getPercentile(0.025);
				_percentileHigh = this.getPercentile(0.975);

				_min = (_minObject = _elm[0]) as Number;
				_max = (_maxObject = _elm[N]) as Number;
				
				var ss:Number = 0, x:Number;
				for each (x in _elm) {
					_sum += x;
					ss += x * x;
				}
				_stdev = Math.sqrt(ss / _num - average * average);
			}
			else
			{
				_minObject = _elm[0];
				_maxObject = _elm[N];
			}
		}
		
		/**
		 * Tests for equality between two values. This method is necessary
		 * because the <code>==</code> operator checks object equality and
		 * not value equality for <code>Date</code> instances.
		 * @param a the first object to compare
		 * @param b the second object to compare
		 * @returns true if the object values are equal, false otherwise
		 */
		public static function equal(a:*, b:*):Boolean
		{
			if (a is Date && b is Date) {
				return (a as Date).time == (b as Date).time;
			} else {
				return a == b;
			}
		}
		
	} // end of class Stats
}