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
	import flash.utils.Dictionary;
	
	import org.juicekit.interfaces.IEvaluable;
	
	/**
	 * Utility methods for working with arrays.
	 */
	public class Arrays
	{
		public static const EMPTY:Array = new Array(0);
		
		/**
		 * Constructor, throws an error if called, as this is an abstract class.
		 */
		public function Arrays() {
			throw new ArgumentError("This is an abstract class.");
		}
		
		/**
		 * Returns the maximum value in an array. Comparison is determined
		 * using the greater-than operator against arbitrary types.
		 * @param a the array
		 * @param p an optional property from which to extract the value.
		 *  If this is null, the immediate contents of the array are compared.
		 * @return the maximum value
		 */
		public static function max(a:Array, p:Property = null):Number
		{
			var x:Number = Number.MIN_VALUE;
			if (p) {
				var v:Number;
				for (var i:uint = 0; i < a.length; ++i) {
					v = p.getValue(a[i]);
					if (v > x) x = v;
				}
			} else {
				for (i = 0; i < a.length; ++i) {
					if (a[i] > x) x = a[i];
				}
			}
			return x;
		}
		
		/**
		 * Returns the index of a maximum value in an array. Comparison is
		 * determined using the greater-than operator against arbitrary types.
		 * @param a the array
		 * @param p an optional property from which to extract the value.
		 *  If this is null, the immediate contents of the array are compared.
		 * @return the index of a maximum value
		 */
		public static function maxIndex(a:Array, p:Property = null):Number
		{
			var x:Number = Number.MIN_VALUE;
			var idx:int = -1;
			
			if (p) {
				var v:Number;
				for (var i:uint = 0; i < a.length; ++i) {
					v = p.getValue(a[i]);
					if (v > x) {
						x = v;
						idx = i;
					}
				}
			} else {
				for (i = 0; i < a.length; ++i) {
					if (a[i] > x) {
						x = a[i];
						idx = i;
					}
				}
			}
			return idx;
		}
		
		/**
		 * Returns the minimum value in an array. Comparison is determined
		 * using the less-than operator against arbitrary types.
		 * @param a the array
		 * @param p an optional property from which to extract the value.
		 *  If this is null, the immediate contents of the array are compared.
		 * @return the minimum value
		 */
		public static function min(a:Array, p:Property = null):Number
		{
			var x:Number = Number.MAX_VALUE;
			if (p) {
				var v:Number;
				for (var i:uint = 0; i < a.length; ++i) {
					v = p.getValue(a[i]);
					if (v < x) x = v;
				}
			} else {
				for (i = 0; i < a.length; ++i) {
					if (a[i] < x) x = a[i];
				}
			}
			return x;
		}
		
		/**
		 * Returns the index of a minimum value in an array. Comparison is
		 * determined using the less-than operator against arbitrary types.
		 * @param a the array
		 * @param p an optional property from which to extract the value.
		 *  If this is null, the immediate contents of the array are compared.
		 * @return the index of a minimum value
		 */
		public static function minIndex(a:Array, p:Property = null):Number
		{
			var x:Number = Number.MAX_VALUE, idx:int = -1;
			if (p) {
				var v:Number;
				for (var i:uint = 0; i < a.length; ++i) {
					v = p.getValue(a[i]);
					if (v < x) {
						x = v;
						idx = i;
					}
				}
			} else {
				for (i = 0; i < a.length; ++i) {
					if (a[i] < x) {
						x = a[i];
						idx = i;
					}
				}
			}
			return idx;
		}
		
		/**
		 * Fills an array with a given value.
		 * @param a the array
		 * @param o the value with which to fill the array
		 */
		public static function fill(a:Array, o:*):void
		{
			for (var i:uint = 0; i < a.length; ++i) {
				a[i] = o;
			}
		}
		
		
		/**
		 * Generates an array containing number values from min to max.
		 * @param a the array
		 * @param o the value with which to fill the array
		 */
		public static function range(from:Number, to:Number, step:Number=1):Array /*int*/
		{
            [ArrayElementType("int")]
			var result:Array = [];
			var n:Number;
			// determine if step is going in the right direction
			if (step == 0 || (from < to && step < 0) || (from > to && step > 0)) {
			} else {
				n = from;
				if (step > 0) {
					while (n < to) {
						result.push(n);
						n += step;
					}
				} else {
					while (n > to) {
						result.push(n);
						n += step;
					}
				}
			}
			return result;
		}
		
		/**
		 * Makes a copy of an array or copies the contents of one array to
		 * another.
		 * @param a the array to copy
		 * @param b the array to copy values to. If null, a new array is
		 *  created.
		 * @param a0 the starting index from which to copy values
		 *  of the input array
		 * @param b0 the starting index at which to write value into the
		 *  output array
		 * @param len the number of values to copy
		 * @return the target array containing the copied values
		 */
		public static function copy(a:Array, b:Array = null, a0:int = 0, b0:int = 0, len:int = -1):Array {
			len = (len < 0 ? a.length : len);
			if (b == null) {
				b = new Array(b0 + len);
			} else {
				while (b.length < b0 + len) b.push(null);
			}
			
			for (var i:uint = 0; i < len; ++i) {
				b[b0 + i] = a[a0 + i];
			}
			return b;
		}
		
		/**
		 * Clears an array instance, removing all values.
		 * @param a the array to clear
		 */
		public static function clear(a:Array):void
		{
			while (a.length > 0) a.pop();
		}
		
		/**
		 * Removes an element from an array. Only the first instance of the
		 * value is removed.
		 * @param a the array
		 * @param o the value to remove
		 * @return the index location at which the removed element was found,
		 * negative if the value was not found.
		 */
		public static function remove(a:Array, o:Object):int {
			var idx:int = a.indexOf(o);
			if (idx == a.length - 1) {
				a.pop();
			} else if (idx >= 0) {
				a.splice(idx, 1);
			}
			return idx;
		}
		
		/**
		 * Removes the array element at the given index.
		 * @param a the array
		 * @param idx the index at which to remove an element
		 * @return the removed element
		 */
		public static function removeAt(a:Array, idx:uint):Object {
			if (idx == a.length - 1) {
				return a.pop();
			} else {
				var x:Object = a[idx];
				a.splice(idx, 1);
				return x;
			}
		}
		
		/**
		 * Performs a binary search over the input array for the given key
		 * value, optionally using a provided property to extract from array
		 * items and a custom comparison function.
		 * @param a the array to search over
		 * @param key the key value to search for
		 * @param prop the property to retrieve from objecs in the array. If null
		 *  (the default) the array values will be used directly.
		 * @param cmp an optional comparison function
		 * @return the index of the given key if it exists in the array,
		 *  otherwise -1 times the index value at the insertion point that
		 *  would be used if the key were added to the array.
		 */
		public static function binarySearch(a:Array, key:Object,
											prop:String = null, cmp:Function = null):int
		{
			var p:Property = prop ? Property.$(prop) : null;
			if (cmp == null)
				cmp = function(a:*, b:*):int {
					return a > b ? 1 : a < b ? -1 : 0;
				}
			
			var x1:int = 0, x2:int = a.length, i:int = (x2 >> 1);
			while (x1 < x2) {
				var c:int = cmp(p ? p.getValue(a[i]) : a[i], key);
				if (c == 0) {
					return i;
				} else if (c < 0) {
					x1 = i + 1;
				} else {
					x2 = i;
				}
				i = x1 + ((x2 - x1) >> 1);
			}
			return -1 * (i + 1);
		}
		
		/**
		 * Sets a named property value for items stored in an array.
		 * The value can take a number of forms:
		 * <ul>
		 *  <li>If the value is a <code>Function</code>, it will be evaluated
		 *      for each element and the result will be used as the property
		 *      value for that element.</li>
		 *  <li>If the value is an <code>IEvaluable</code> instance, it will be
		 *      evaluated for each element and the result will be used as the
		 *      property value for that element.</li>
		 *  <li>In all other cases, the property value will be treated as a
		 *      literal and assigned for all elements.</li>
		 * </ul>
		 * @param list the array to set property values for
		 * @param name the name of the property to set
		 * @param value the value of the property to set
		 * @param filter a filter function determining which items
		 *  in the array should be processed
		 * @param p an optional <code>IValueProxy</code> for setting the values
		 */
		public static function setProperty(a:Array,
										   name:String, value:*, filter:Function, p:IValueProxy = null):void
		{
			if (p == null) p = Property.proxy;
			var v:Function = value is Function ? value as Function :
				value is IEvaluable ? IEvaluable(value).eval : null;
			for each (var o:Object in a) if (filter == null || filter(o))
				p.setValue(o, name, v != null ? v(p.$(o)) : value);
		}
		
		
		
		/**
		 * Join two arrays
		 * 
		 * @param a an Array
		 * @param b an Array
		 * @param joinType One of "inner", "outer", "left", default is "inner"
		 * @param joinBy An Array of properties, or a String containing a single property, or a 
		 *               key generation function of signature function(o:Object):String
		 * @param constructor A function for generating new objects of signature 
		 *                    function(a:Object, b:Object):Object
		 * @returns a joined array
		 */
		public static function join(a:Array, b:Array, joinType:String='inner', joinBy:Object=null, constructor:*=null):Array
		{			
			
			// A factory function to create key generation functions	
			function keyFactory(propFields:*):Function
			{
				function DEFAULT(o:Object):String {
					return '';
				}
				
				const joinSeparator:String = '###';
				var prop:Property;
				
				if (propFields is Function)
				{
					return propFields as Function;
				}
				else if (propFields is String)
				{
					prop = Property.$(propFields as String);
					return function(o:Object):String {
						return prop.getValue(o).toString();
					}
				}
				else if (propFields is Array) {
					var propArr:Array = propFields as Array;
					if (propArr.length == 0)
					{
						return DEFAULT;
					}
					else if (propArr.length == 1)
					{
						prop = Property.$(propFields[0] as String);
						return function(o:Object):String {
							return prop.getValue(o).toString();
						}
					}
					else 
					{
						var props:Array = [];
						for each (var propField:String in propArr)
						{
							props.push(Property.$(propField));
						}
						return function(o:Object):String {
							var keys:Array = [];
							for each (prop in props)
							keys.push(prop.getValue(o).toString());
							return keys.join(joinSeparator);
						}
					}
				}
				else 
				{
					return DEFAULT;
				}
			}
			
			// A factory function for creating object constructors (that merge
			// two matched objects
			function constructorFactory(constructor:*):Function
			{
				function DEFAULT(a:Object, b:Object):Object {
					var o:Object = {};
					var k:String;
					if (a)
						for (k in a)
							o[k] = a[k];
					
					if (b)
						for (k in b)
							o[k] = b[k];
					
					return o;
				}
				
				if (constructor is Function) 
					return constructor;
				else
					return DEFAULT;
				
			}
			
			
			var key:String, aObj:Object, bObj:Object;
			var lookup:Dictionary = new Dictionary();
			
			// If joinBy is not specified, build a list of matching keys
			// and use that
			if (joinBy == null && a.length > 0 && b.length > 0) {
				joinBy = [];
				aObj = a[0];
				bObj = b[0];
				for (key in aObj) {
					if (bObj.hasOwnProperty(key)) 
						joinBy.push(key);
				}
			}
			
			var keyGenerator:Function = keyFactory(joinBy);
			var objectConstructor:Function = constructorFactory(constructor);
			
			// Build lookup dict from b
			var idx:int;
			var len:int = b.length;
			for (idx=0; idx<len; idx++)
			{
				bObj = b[idx];
				lookup[keyGenerator(bObj)] = bObj; 
			}
			
			
			// Iterate over a
			var result:Array = [];
			len = a.length;
			for (idx=0; idx<len; idx++)
			{
				aObj = a[idx];
				// build key
				key = keyGenerator(aObj);
				// check each item in b
				if (lookup[key] != undefined)
					bObj = lookup[key];
				else
					bObj = null;
				if (joinType == 'inner' && bObj == null) 
					continue;
				
				result.push(objectConstructor(aObj, bObj));
			}
			
			// If outer, add only items that are in B but not in A
			if (joinType == 'outer')
			{
				// Build lookup dict from a
				lookup = new Dictionary();
				len = a.length;
				for (idx=0; idx<len; idx++)
				{
					aObj = a[idx];
					lookup[keyGenerator(aObj)] = aObj; 
				}					
				
				len = b.length;
				for (idx=0; idx<len; idx++)
				{
					bObj = b[idx];
					// build key
					key = keyGenerator(bObj);
					// check each item in b
					if (lookup[key] === undefined)
					{
						result.push(objectConstructor(null, bObj));
					}
				}
			}
			
			return result;
		}
		
		
	} // end of class Arrays
}