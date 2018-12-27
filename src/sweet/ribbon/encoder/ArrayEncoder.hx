package sweet.ribbon.encoder;
import sweet.ribbon.encoder.ISubEncoder;

/**
 * ...
 * @author GINER Jeremy
 */
class ArrayEncoder implements ISubEncoder<Array<Dynamic>> {
	
	public function new() {	}
	public function encode( o :Array<Dynamic>, i :Null<Int> = null ) {
		return (new IntEncoder()).encode( o.length ); //TODO use singleton
	}
	public function getChildAr( aArray :Array<Dynamic> ) {
		var a = new List<Dynamic>();
		for( o in aArray )
			a.push( o );
		return a;
	}
	
	public function getMappingInfo( aArray :Array<Dynamic> ) {
		return null;
	}
}