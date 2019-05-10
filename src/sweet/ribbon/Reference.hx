package sweet.ribbon;

/**
 * Used to replace a reference to an object encoded or being encoded. 
 * @author GINER Jeremy
 */
class Reference {
	
	var _iId :Int;
	
	public function new( iId :Int ) {
		_iId = iId;
	}
	public function getId() {
		return _iId;
	}
}