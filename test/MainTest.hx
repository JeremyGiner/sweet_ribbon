package;
import haxe.ds.StringMap;
import sweet.ribbon.MappingInfo;
import sweet.ribbon.RibbonDecoder;
import sweet.ribbon.RibbonEncoder;
import sweet.ribbon.RibbonMacro;
import sweet.ribbon.RibbonStrategy;
import sweet.ribbon.MappingInfoProvider;
import toto.DataTest1;
import toto.DataTest1Extended;

/**
 * ...
 * @author GINER Jeremy
 */
class MainTest {

	static public function main() {
		
		//new TESTIMPORT();
		
		trace('Test 1 : Encode decode toto.DataTest1 ...');
		
		var oMappingInfoProvider = new MappingInfoProvider();
		
		//trace( Type.getClassName( DataTest1 ) );
		oMappingInfoProvider.set( 
			new MappingInfo( 
				Type.getClassName( DataTest1 ), 
				RibbonMacro.getClassFieldNameAr( DataTest1 )
			)
		);
		
		RibbonMacro.setMappingInfo( oMappingInfoProvider, DataTest1 );
		RibbonMacro.setMappingInfo( oMappingInfoProvider, DataTest1Extended );
		
		//RibbonMacro.TEST();
		
		var oStrategy = new RibbonStrategy( oMappingInfoProvider );
		
		var oEncoder = new RibbonEncoder( oStrategy );
		//var oEncoder = new sweet.ribbon.debug.RibbonEncoderDebug( oStrategy );
		var oDecoder = new RibbonDecoder( oStrategy );
		//var oDecoder = new RibbonDecoderDebug( oStrategy );
		
		var oDataTest1 = new DataTest1();
		
		trace('Encoding ...');
		var oBytes = oEncoder.encode( oDataTest1 );
		trace('Decoding : '+oBytes.toHex());
		var oDecodedDate1 = oDecoder.decode( oBytes );
		
		trace('Testing result ...');
		
		// cannot use Std.string( oDecodedDate1 ), does not handle recursion veru well
		
		trace( oDataTest1.assertEqual( cast oDecodedDate1 ) );
	}
	
}

