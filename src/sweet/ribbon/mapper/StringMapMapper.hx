package sweet.ribbon.mapper;
import haxe.ds.StringMap;

/**
 * Mapper for a haxe.ds.StingMap object
 * @author GINER Jeremy
 */
class StringMapMapper extends AMapper<StringMap<Dynamic>> {
	override public function addChild( o:Dynamic ) {
		super.addChild(o);
		
		var iLastIndex = _aChild.length - 1;
		
		getObject().set( 
			_oClassDesc.getFieldNameAr()[iLastIndex], 
			_aChild[iLastIndex] 
		);
		return this;
	}
	override public function createObject() {

		return new StringMap<Dynamic>();
	}
}