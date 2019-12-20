# Ribbon Encoder/Decoder (Serializer/Unserializer)

An encoder/decoder for a specific binary format nammed Ribbon, made with Haxe.

### Feature
- binary encoding for light weight result
- keep class of class instances
- handle circular reference and multiple reference to the same object
- encode anything but enum so far ( coming eventually )
- flexible ( see customize section)
- ignore static var

### Limitation
- for each class a mapping info must be declared ( RibbonMacro make it less fastidious but still )
- annonymous class not implemented yet
- enum not implemented yet ( and in low priority unless someone esle want to do it )

### Compare to Haxe native Serializer/Deserializer

\  | native | ribbon
--- | --- | ---
Circular reference | clone or infinite loop | process object once then use reference
Multiple reference | copy object | handle as same object
Annonymous class / Enum | handle as expected | not implemented

## Getting Started

### Installing

Just use haxe lib

```
haxelib git sweet.functor https://github.com/JeremyGiner/sweet_ribbon.git
```

### Use

Then use the library in your build.hxml :
```
[...]
-lib sweet.ribbon
[...]
```

```
// Creating the mapping info provider
var oMappingInfoProvider = new MappingInfoProvider();
// Provider can be set like so ...
oMappingInfoProvider.set( 
  new MappingInfo( 
    Type.getClassName( DataTest1 ), 
    RibbonMacro.getClassFieldNameAr( DataTest1 )
  )
);
// ... Or you can use a macro which generate the code above
RibbonMacro.setMappingInfo( oMappingInfoProvider, DataTest1 );
// Creating strategy
var oStrategy = new RibbonStrategy( oMappingInfoProvider );
// Creating encoder / decoder
var oEncoder = new RibbonEncoder( oStrategy );
var oDecoder = new RibbonDecoder( oStrategy );
// Encoding / decoding some object
var oDataTest1 = new DataTest1();
trace('Encoding ...');
var oBytes = oEncoder.encode( oDataTest1 );
trace('Decoding : '+oBytes.toHex());
var oDecodedDate1 = oDecoder.decode( oBytes );
```

## Ribbon format

The binary 
```
Bytes format
[4] count of class type
	[4] class full name size
	[X] class full name
	[4] field count
		[1] field name size
		[X] field name 
[1] type ( value of index define by the strategy )
	case type array
		[4] array size
		match following X data as a value
	case type string
		[1] string size X
		[X] string data
	case type map
	case type class instance 
		[1] class index ( see above )
		match next data with field
	case type ref to
		[4] index of object in the sequence
	case else
		[X] data
```

## Customize

TODO : explain
extends Strategy

## Author

* **Jérémy GINER** - *Initial work* - [JeremyGiner](https://github.com/JeremyGiner)
