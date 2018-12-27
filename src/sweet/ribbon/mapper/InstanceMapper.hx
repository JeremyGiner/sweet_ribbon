package sweet.ribbon.mapper;

/**
 * Mapper using reflection and a provided class name to create and hydrate an 
 * instance
 * @author GINER Jeremy
 */
class InstanceMapper extends AMapper<Dynamic> {
	override public function addChild( o:Dynamic ) {
		super.addChild(o);
		Reflect.setField( 
			getObject(), 
			_oClassDesc.getFieldNameAr()[ _aChild.length-1 ], 
			_aChild[_aChild.length-1] 
		);//TODO: safe mode?
		
		return this;
	}
	override public function createObject() {
		
		var o = Type.createEmptyInstance( 
			Type.resolveClass( _oClassDesc.getClassName() ) 
		);
		return o;
	}
}