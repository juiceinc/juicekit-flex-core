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

package org.juicekit.collections {
    
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.events.CollectionEvent;
    import mx.utils.UIDUtil;
    
    import org.juicekit.animate.Transitioner;
    import org.juicekit.util.Property;
    import org.juicekit.util.Stats;
    
    
    /**
     * The StatsArrayCollection class is a wrapper class that exposes an ArrayCollection.
     * Stats objects can be created that are synced to the content of the
     * ArrayCollection. 
     *
     * @author Chris Gemignani
     * @author Sal Uryasev
     *
     **/
    public class StatsArrayCollection extends ArrayCollection {
        
        /** Cache of Stats objects for item properties. */
        private var _stats:Object = {};
        
        /**
         * Constructor
         */
        public function StatsArrayCollection(source:Array = null) {
            super(source);
        }
        
        
        //-----------------------
        // utilities
        //-----------------------
        
        /**
         * Utility function to clone an object
         */
        protected function cloneObj(source:Object):* {
            var myBA:ByteArray = new ByteArray();
            myBA.writeObject(source);
            myBA.position = 0;
            return (myBA.readObject());
        }
        
        
        //----------------------------------
        // dataProvider
        //----------------------------------
        
        public function set dataProvider(v:ArrayCollection):void {
            if (dataProvider) {
                dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, acCollectionChange);
            }
            _dataProvider = v;
            dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, acCollectionChange);
            source = v.source;
        }
        
        public function get dataProvider():ArrayCollection {
            return _dataProvider;
        }
        
        private var _dataProvider:ArrayCollection = null;
        
        protected function acCollectionChange(e:CollectionEvent):void {
            source = _dataProvider.source;
            dispatchEvent(new Event('statsChanged'));			
        }
        
        
        
        //-----------------------
        // stats
        //-----------------------
        
        
        /**
         * Computes and caches statistics for a data field. The resulting
         * <code>Stats</code> object is cached, so that later access does not
         * require any re-calculation. The cache of statistics objects may be
         * cleared, however, if changes to the data set are made.
         * @param field the property name
         * @return a <code>Stats</code> object with the computed statistics
         */
        [Bindable(event='statsChanged')]
        public function stats(field:String):Stats
        {
            // TODO: allow custom comparators?
            
            if (!_addedStatsListener) {
                this.addEventListener(CollectionEvent.COLLECTION_CHANGE, clearAllStats);
                _addedStatsListener = true;
            }
            
            
            // check cache for stats
            if (_stats[field] != undefined) {
                return _stats[field] as Stats;
            } else {
                return _stats[field] = new Stats(list.toArray(), field);
            }
            
        }
        
        private var _addedStatsListener:Boolean = false;
        
        
        /**
         * Clears any cached stats for the given field.
         * @param field the data field to clear the stats for.
         */
        public function clearStats(field:String):void
        {
            delete _stats[field];
        }
        
        /**
         * Clears any cached stats for all fields.
         * @param e an optional CollectionEvent
         */
        public function clearAllStats(e:CollectionEvent = null):void
        {
            _stats = {};
            dispatchEvent(new Event('statsChanged'));
        }
        
                
    }
}