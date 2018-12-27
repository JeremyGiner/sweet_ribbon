package sweet.ribbon.tool;
import haxe.io.Bytes;

/**
 * ...
 * @author GINER Jeremy
 */
class BytesReader {
	
	var _oBytes :Bytes;
	var _iPosition :Int;
	
//_____________________________________________________________________________
//	Constructor method

	public function new( oBytes :Bytes, iPosition :Int = 0 ) {
		_oBytes = oBytes;
		_iPosition = iPosition;
	}
	
	public function clone() { //TODO: use cloner
		return new BytesReader( _oBytes, _iPosition );
	}
	
//_____________________________________________________________________________
//	Accessor

	public function getBytes() {
		return _oBytes;
	}

	public function getPosition() {
		return _iPosition;
	}

//_____________________________________________________________________________
//	Modifier
	
	public function reset() {
		_iPosition = 0;
		return this;
	}
	public function setPosition( iPosition :Int ) {
		_iPosition = iPosition;
		return this;
	}
	
//_____________________________________________________________________________
//	Reading method

	
	public function read() {
		return _oBytes.get( _iPosition++ );
	}
	public function readInt32() {
		var i = _oBytes.getInt32( _iPosition );
		_iPosition += 4;
		return i;
	}
	public function readInt64(){
		var i = _oBytes.getInt64( _iPosition );
		_iPosition += 8;
		return i;
	}
	public function readString( iLength :Int ){
		var s = _oBytes.getString( _iPosition, iLength );
		_iPosition += iLength;
		return s;
	}
	
	public function readSizedString() {
		var iLength = readInt32();
		return readString( iLength );
	}
	
	public function readBytes( iLength :Int ) {
		var o = _oBytes.sub( _iPosition, iLength );
		_iPosition += iLength;
		return o;
	}
}