package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;

/**
 * @author GINER Jeremy
 */
interface ISubDecoderBaseType<C> {
	/**
	 * Intreface used by RibbonDecoder to decode Bytes into an indivdual value
	 * IMPORTANT : Must move the reader position to  the next value
	 * @param	oReader
	 * @return  Decoded value
	 */
	public function decode( oReader :BytesReader ) :C;
}