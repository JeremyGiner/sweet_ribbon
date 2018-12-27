package sweet.ribbon.encoder;
import sweet.ribbon.IMappingInfoProvider;
import sweet.ribbon.encoder.ISubEncoder;

/**
 * ...
 * @author GINER Jeremy
 */
class InstanceEncoder implements ISubEncoder<Dynamic> {
	
	var _oMappingInfoProvider :IMappingInfoProvider;
	
	public function new( oMappingInfoProvider :IMappingInfoProvider ) {
		_oMappingInfoProvider = oMappingInfoProvider;
	}
	public function encode( o :Dynamic, i :Null<Int> = null ) {
		return (new IntEncoder()).encode( i ); //TODO use singleton
	}
	public function getChildAr( o :Dynamic ) {
		var a = new List<Dynamic>();
		for ( sField in _oMappingInfoProvider.getMappingInfo( o ).getFieldNameAr() )
			a.push( Reflect.field( o, sField ) );
		return a;
	}
	
	public function getMappingInfo( o :Dynamic ) {
		return _oMappingInfoProvider.getMappingInfo( o );
	}
}