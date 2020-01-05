package sweet.ribbon.encoder;
import haxe.ds.IntMap;
import sweet.ribbon.MappingInfo;
import sweet.ribbon.encoder.ISubEncoder;
import haxe.ds.StringMap;

/**
 * ...
 * @author GINER Jeremy
 */
class IntMapEncoder implements ISubEncoder<IntMap<Dynamic>> {
	
	public function new() {	}
	public function encode( o :IntMap<Dynamic>, i :Null<Int> = null ) {
		return (new IntEncoder()).encode( i ); //TODO use singleton
	}
	public function getChildAr( oMap :IntMap<Dynamic> ) {
		var a = new List<Dynamic>();
		for( oChild in oMap )
			a.push( oChild );
		return a;
	}
	
	public function getMappingInfo( oMap :IntMap<Dynamic> ) {
		return new MappingInfo( 'IntMap', [ for( s in oMap.keys() ) ''+s] );
	}
}