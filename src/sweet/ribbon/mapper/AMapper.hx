package sweet.ribbon.mapper;
import sweet.ribbon.MappingInfo;

/**
 * Default abstract mapper
 * @author GINER Jeremy
 */
class AMapper<C> implements IMapper<C> {
	
	var _oClassDesc :MappingInfo;
	var _aChild :Array<Dynamic>;
	
	var _oObject :C;
	
	public function new( oClassDesc :MappingInfo ) {
		_oClassDesc = oClassDesc;
		_aChild = new Array<Dynamic>();
		_oObject = createObject();
	}
	
	public function getObject() :C {
		return _oObject;
	}
	
	public function getChildCount() {
		return _aChild.length;
	}
	
	public function isFilled() {
		return getChildCount() >= _oClassDesc.getFieldNameAr().length;
	}
	
	public function addChild( o :Dynamic ) {
		_aChild.push( o );
		return this;
	}
	
	public function createObject() :C {
		throw 'This method is abstract, override it';
		return null;
	}
}