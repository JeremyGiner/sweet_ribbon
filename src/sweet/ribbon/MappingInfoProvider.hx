package sweet.ribbon;
import haxe.ds.StringMap;

/**
 * Default MappingInfo provider
 * Store mapping info for a class and 
 * give mapping info of a class instance using its associated class
 * @author GINER Jeremy
 */
class MappingInfoProvider implements IMappingInfoProvider {
	/**
	 * Indexed by class name
	 */
	var _mMappingInfo :StringMap<MappingInfo>;
	
	public function new( mMappingInfo :StringMap<MappingInfo> = null ) {
		
		_mMappingInfo = mMappingInfo != null ?
			mMappingInfo :
			new StringMap<MappingInfo>()
		;
		
	}
	
	public function getMappingInfo( o :Dynamic ) {
		return getByClass( Type.getClass( o ) );
	}
	
	public function getByClass( oClass :Class<Dynamic> ) {
		var s = Type.getClassName( oClass );
		
		if ( ! _mMappingInfo.exists( s ) )
			//_mMappingInfo.set( s, generate( oClass ) );
			throw 'MappingInfo for class "'+s+'" does not exist';
		return _mMappingInfo.get( s );
	}
	
	public function set( oMappingInfo :MappingInfo ) {
		_mMappingInfo.set( oMappingInfo.getClassName(), oMappingInfo );
		return this;
	}
}