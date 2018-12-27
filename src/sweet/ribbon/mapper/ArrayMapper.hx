package sweet.ribbon.mapper;

/**
 * Mapper for an Array
 * @author GINER Jeremy
 */
class ArrayMapper implements IMapper<Array<Dynamic>>  {
	
	var _aChild :Array<Dynamic>;
	
	var _iLength :Int;// length desired
	var _a :Array<Dynamic>;
	
	public function new( iLength : Int ) {
		_iLength = iLength;
		_a = createObject();
	}
	
	public function getObject() {
		return _a;
	}
	
	public function getChildCount() {
		return _iLength;
	}
	
	public function isFilled() {
		return _a.length == getChildCount();
	}
	
	public function addChild( o :Dynamic ) {
		_a.push( o );
		return this;
	}
	
	public function createObject() {
		return new Array<Dynamic>();
	}
}