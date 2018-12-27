package sweet.ribbon.tool;
import haxe.Int64;
import haxe.io.Bytes;

/**
 * ...
 * @author GINER Jeremy
 */
class BytesWriter {
	
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
//	Writing method

	
	public function write( i :Int ) {
		_oBytes.set( _iPosition++, i );
		return this;
	}
	public function writeInt32( i :Int ) {
		_oBytes.setInt32( _iPosition, i );
		_iPosition += 4;
		return this;
	}
	public function writeInt64( i :Int64 ) {
		_oBytes.setInt64( _iPosition, i );
		_iPosition += 8;
		return this;
	}
	/*
	 * TODO
	public function writeString( s :String ) {
		throw 'not implemented yet';
		return this;
	}
	
	public function writeSizedString( s :String ) {
		throw 'not implemented yet';
		return this;
	}
	*/
	public function writeBytes( oBytes :Bytes ) :BytesWriter {
		//TODO : throw error on invalid length
		for( i in 0...oBytes.length )
			_oBytes.set( _iPosition++, oBytes.get( i )  );
		
		return this;
	}
}