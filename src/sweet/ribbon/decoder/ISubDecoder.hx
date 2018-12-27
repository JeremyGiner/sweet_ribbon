package sweet.ribbon.decoder;
import sweet.ribbon.RibbonStrategy;
import sweet.ribbon.tool.BytesReader;
import sweet.ribbon.MappingInfo;
import sweet.ribbon.mapper.IMapper;

/**
 * @author GINER Jeremy
 */
interface ISubDecoder {
	/**
	 * Must move the reader position
	 * @param	oReader
	 * @param	aMapping
	 * @return
	 */
	public function decode( 
		oReader :BytesReader, 
		aMapping :Array<MappingInfo> 
	) :IMapper<Dynamic>;
}