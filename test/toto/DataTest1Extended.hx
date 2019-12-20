package toto;

/**
 * ...
 * @author GINER Jeremy
 */
class DataTest1Extended<C:String> extends DataTest1 {

	var _sMoreField :C;
	
	public function new() {
		super( false );
		
		_sMoreField = cast 'TEST';
	}
	
	
	public function moreAssertEqual( o :DataTest1Extended<String> ) :Bool {
		
		super.assertEqual( o );
		
		if ( _sMoreField != _sMoreField ) throw '_sMoreField is not equal';
		
		return true;
	}
}