package
org.juicekit {
/**
 * Test suite for utility classes
 * [RunWith("org.flexunit.runners.Suite")]
 */
[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class UtilTestSuite {
    public var testAnimation:TestAnimation;
    public var colorTests:TestColor;
    public var matrixTests:TestMatrix;
    public var propertyTests:TestProperty;
    public var sortTests:TestSort;
    public var stringsFormatTests:TestStringsFormat;
}
}