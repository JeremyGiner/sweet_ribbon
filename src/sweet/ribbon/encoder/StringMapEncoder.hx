package sweet.ribbon.encoder;
import sweet.ribbon.MappingInfo;
import sweet.ribbon.encoder.ISubEncoder;
import haxe.ds.StringMap;

/**
 * ...
 * @author GINER Jeremy
 */
class StringMapEncoder implements ISubEncoder<StringMap<Dynamic>> {
	
	public function new() {	}
	public function encode( o :StringMap<Dynamic>, i :Null<Int> = null ) {
		return (new IntEncoder()).encode( i ); //TODO use singleton
	}
	public function getChildAr( oMap :StringMap<Dynamic> ) {
		var a = new List<Dynamic>();
		for( oChild in oMap )
			a.push( oChild );
		return a;
	}
	
	public function getMappingInfo( oMap :StringMap<Dynamic> ) {
		return new MappingInfo( 'StringMap', [ for( s in oMap.keys() ) s] );
	}
}