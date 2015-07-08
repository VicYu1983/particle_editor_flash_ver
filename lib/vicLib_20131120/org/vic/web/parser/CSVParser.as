package org.vic.web.parser 
{
	/**
	 * ...
	 * @author fff
	 */
	public class CSVParser 
	{
		private var _ary:Array;
		private var _rowCount:int;
		private var _colCount:int;
		
		public function CSVParser( data:String, rowCount:int = 1, colCount:int = 1 ) 
		{
			data = data.split( '\n' ).join( ',' );
			_ary = data.split(',');
			_rowCount = rowCount;
			_colCount = colCount;
		}
		
		public function getValue( r:int, c:int ):String {
			if ( r >= _rowCount ) {
				throw Error( 'invalid rol' );
			}
			if ( c >= _colCount ) {
				throw Error( 'invalid col' );
			}
			return _ary[r * _colCount + c ];
		}
	}

}