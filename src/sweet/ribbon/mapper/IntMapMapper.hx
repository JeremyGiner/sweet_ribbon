package sweet.ribbon.mapper;
import haxe.ds.IntMap;

/**
 * Mapper for a haxe.ds.StingMap object
 * @author GINER Jeremy
 */
class IntMapMapper extends AMapper<IntMap<Dynamic>> {
	override public function addChild( o:Dynamic ) {
		super.addChild(o);
		
		var iLastIndex = _aChild.length - 1;
		
		getObject().set( 
			Std.parseInt(_oClassDesc.getFieldNameAr()[iLastIndex]), // encode int 
			_aChild[iLastIndex] 
		);
		return this;
	}
	override public function createObject() {

		return new IntMap<Dynamic>();
	}
}