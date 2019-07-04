package sweet.ribbon;

/**
 * ...
 * @author GINER Jeremy
 */
class MappingInfo {

	var _sClassName :String;
	var _aFieldName :Array<String>;
	
	public function new( sClassName :String, aFieldName :Array<String> ) {
		_sClassName = sClassName;
		_aFieldName = aFieldName;
	}
	
	public function getFieldNameAr() {
		return _aFieldName;
	}
	
	public function getClassName() {
		return _sClassName;
	}
	
	public function toString() {
		return 'MappingInfo#' + _sClassName+'#'+_aFieldName.toString();
	}
}