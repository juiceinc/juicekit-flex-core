package org.juicekit{
import org.juicekit.util.Colors;

import flexunit.framework.TestCase;

import mx.collections.ArrayCollection;


/**
 * Tests of Color utility library
 */
public class TestColor extends TestCase {

    public function testSaturation():void {
        var x:int = 3;
        assertEquals(x, 3);
    }

}
}