package toto;
import haxe.ds.StringMap;

/**
 * ...
 * @author GINER Jeremy
 */
class DataTest1 {
	
	var _n :Dynamic;
	var _bTrue :Bool;
	var _bFalse :Bool;
	var _i :Int;
	var _s :String;
	var _self :DataTest1;
	var _m :StringMap<Int>;
	var _a2 :Array<Int>;
	var _aEmpty :Array<Int>;
	
	var _extended :DataTest1Extended<String>;
	
	public function new( bAddExtended :Bool = true ) {
		_n = null;  
		_bTrue = true;
		_bFalse = false;
		_i = 25;
		_s = 'Some string';
		_self = this;
		_m = [
			'1' => 1,
			'sqdq' => 2,
			'aaaaa' => -5,
		];
		_a2 = [10, 11];
		_aEmpty = [];
		
		if( bAddExtended ) 
			_extended = new DataTest1Extended<String>();
		else
			_extended = null;
	}
	
	public function assertEqual( o :DataTest1 ) :Bool {
		if( _n != o._n ) throw '_n is not equal';
		if( _bTrue != o._bTrue ) throw '_bTrue is not equal';
		if( _bFalse != o._bFalse ) throw '_bFalse is not equal';
		if ( _i != o._i ) throw '_i is not equal';
		if ( _s != o._s ) throw '_s is not equal';
		
		if ( _a2.toString() != o._a2.toString() ) throw '_a2 is not equal : ' +o._a2 + ' should be ' + _a2;
		if ( _aEmpty.toString() != o._aEmpty.toString() ) throw '_aEmpty is not equal : ' +o._aEmpty + ' should be ' + _aEmpty;
		
		if ( o._self != o ) throw '_self is not equal';
		
		for ( sKey in _m.keys() ) {
			if ( _m.get( sKey ) != o._m.get( sKey ) )
				throw 'key #'+sKey+' of _m is not equal';
		}
		
		if ( _extended != null && !_extended.moreAssertEqual(o._extended) ) throw '?!';
		
		return true;
	}
}