package sweet.ribbon.encoder;
import sweet.ribbon.RibbonStrategy;
import haxe.io.Bytes;
import sweet.ribbon.MappingInfo;

/**
 * Interface for a sub-encoder of structure 
 * If object cannot be divided into sub-element use ISubEncoderBaseType instead.
 * @author GINER Jeremy
 */
interface ISubEncoder<C> {
	
	/**
	 * Get MappingInfo for given object o
	 * @param	o
	 * @return	MappingInfo if any or null otherwise
	 */
	public function getMappingInfo( o :C ) :MappingInfo;
	
	/**
	 * Get child of the object o which must be encoded with it
	 * For example the value of a Map
	 * @param	o
	 * @return	list of child object
	 */
	public function getChildAr( o :C ) :List<Dynamic>;
	
	/**
	 * Encode o into Bytes
	 * @param	o
	 * @param	iMappingInfoIndex
	 * @return	encoded o into Bytes
	 */
	public function encode( o :C, iMappingInfoIndex :Null<Int> = null ) :Bytes;
}