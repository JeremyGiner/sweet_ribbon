package sweet.ribbon.tool;
import haxe.io.Bytes;

/**
 * ...
 * @author GINER Jeremy
 */
class BytesTool {
	public static function joinList( l :List<Bytes> ) {
		// Get length sum
		var iLength = 0;
		for ( oBytes in l ) {
			iLength += oBytes.length;
		}
		
		var oBytesWriter = new BytesWriter( Bytes.alloc( iLength ) );
		
		for ( oBytes in l ) {
			trace('write : ' + oBytes.toHex());
			oBytesWriter.writeBytes( oBytes );
		}
		
		return oBytesWriter.getBytes();
	}
}