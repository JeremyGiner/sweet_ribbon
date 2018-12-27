package sweet.ribbon.decoder;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.RibbonStrategy.Reference;

/**
 * ...
 * @author GINER Jeremy
 */
class ReferenceDecoder implements ISubDecoderBaseType<Reference> {
	public function new() {}
	public function decode( oReader :BytesReader ) {
		return new Reference( oReader.readInt32() ); 
	}
}