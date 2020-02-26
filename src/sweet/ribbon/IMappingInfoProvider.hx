package sweet.ribbon;
import sweet.functor.IFunction;

/**
 * Provide a MappingInfo for a given object
 * TODO : use a more generic interface
 * @author GINER Jeremy
 */
interface IMappingInfoProvider {
	public function getMappingInfo( o :Dynamic) :MappingInfo;
	public function getByClass( oClass :Class<Dynamic> ) :MappingInfo;
}