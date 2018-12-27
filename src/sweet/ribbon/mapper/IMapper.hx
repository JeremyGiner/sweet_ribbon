package sweet.ribbon.mapper;

/**
 * Mapper interface
 * Interface used by RibbonDecoder to hydrate a structure ( object with child 
 * in the binary format )
 * @author GINER Jeremy
 */
interface IMapper<C> {
	public function getChildCount() :Int;
	public function isFilled() :Bool;
	public function addChild( o :Dynamic ) :IMapper<C>;
	public function createObject() :C;
	public function getObject() :C;
}