package sweet.ribbon.encoder;
import sweet.ribbon.IMappingInfoProvider;
import sweet.ribbon.MappingInfo;
import sweet.ribbon.encoder.ISubEncoder;

/**
 * ...
 * @author GINER Jeremy
 */
class StructureEncoder implements ISubEncoder<Dynamic> {
	
	public function new() {
	}
	public function encode( o :Dynamic, iClassDescIndex :Null<Int> = null ) {
		return (new IntEncoder()).encode( iClassDescIndex ); //TODO use singleton
	}
	public function getChildAr( o :Dynamic ) {
		var a = new List<Dynamic>();
		for ( sField in Reflect.fields(o) )
			a.push( Reflect.field( o, sField ) );
		return a;
	}
	
	public function getMappingInfo( o :Dynamic ) {
		return new MappingInfo('',Reflect.fields(o));
	}
}