package com.potmo.util.containers.quadtree
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * Spatial search structure for DisplayObject objects
	 *
	 * small example:
	 *
	 * var s1:Sprite = new Sprite();
	 *	s1.x = 10;
	 *	s1.y = 10;
	 *
	 *	var s2:Sprite = new Sprite();
	 *	s2.x = 70;
	 *	s2.y = 70;
	 *
	 *	var tree:QuadTree = new QuadTree(0, 0, stage.stageWidth, stage.stageHeight);
	 *	tree.insert(s1);
	 *	tree.insert(s2);
	 *
	 *	trace(tree.search(new Rectangle(10, 10, 61, 61)));
	 *
	 * @author Yannick (nl.yannickl88.util fount at http://pastebin.com/LF0MXPjt)
	 */
	public class QuadTree
	{
		// minimum size of a subdivsion
		public static const MINSIZE:int = 10;

		private var _parent:QuadTree;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;

		private var _objects:Vector.<DisplayObject>;
		private var _subdivisions:Vector.<QuadTree>;


		//TODO: QuadTree objects should not be DisplayObject but some kind of interface that is better.
		// Maybe dirty objects should be stored in a list and updated at command instead of when unit moves through a function

		/**
		 * Constructor
		 *
		 * @param	int x
		 * @param	int y
		 * @param	int width
		 * @param	int height
		 * @param	QuadTree parent
		 */
		public function QuadTree( x:int, y:int, width:int, height:int, parent:QuadTree = null )
		{
			_parent = parent;
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_objects = new Vector.<DisplayObject>();
			_subdivisions = null;
		}


		/**
		 * Get the amount of nodes which fall in this section (note: also those in sub regions)
		 */
		public function get size():int
		{
			var total:int = 0;

			if ( _subdivisions != null )
			{
				total += _subdivisions[ 0 ].size + _subdivisions[ 1 ].size + _subdivisions[ 2 ].size + _subdivisions[ 3 ].size;
			}
			else
			{
				total += _objects.length;
			}

			return total;
		}


		/**
		 * get the width of this region
		 */
		public function get width():int
		{
			return _width;
		}


		/**
		 * get the height of this region
		 */
		public function get height():int
		{
			return _height;
		}


		/**
		 * get the x value of this region
		 */
		public function get x():int
		{
			return _x;
		}


		/**
		 * get the y value of this region
		 */
		public function get y():int
		{
			return _y;
		}


		/**
		 * Insert a DisplayObject into the tree
		 *
		 * @param	DisplayObject i
		 */
		public function insert( i:DisplayObject ):void
		{
			if ( _subdivisions == null )
			{
				if ( _objects.length > 0 && width > QuadTree.MINSIZE * 2 && height > QuadTree.MINSIZE * 2 )
				{
					_subdivide();
					_getSub( i.x, i.y ).insert( i );
				}
				else
				{
					_objects.push( i );
				}
			}
			else
			{
				_getSub( i.x, i.y ).insert( i );
			}
		}


		/**
		 * remove a DisplayObject from the tree
		 *
		 * @param	DisplayObject i
		 */
		public function remove( i:DisplayObject ):void
		{
			if ( _objects != null )
			{
				for ( var j:int = 0; j < _objects.length; j++ )
				{
					if ( _objects[ j ] == i )
					{
						_objects.splice( j, 1 );
						_fix();
						return;
					}
				}
			}
		}


		/**
		 * Notify the tree of an update of a node
		 *
		 * NOTE: this will just remove the node and reinsert it.
		 * @param	DisplayObject i
		 */
		public function move( i:DisplayObject, x:int, y:int ):void
		{
			var s:QuadTree = _getLeaf( i.x, i.y );
			var s2:QuadTree = _getLeaf( x, y );

			if ( s != s2 )
			{
				s.remove( i );

				i.x = x;
				i.y = y;
				insert( i );
			}
			else
			{
				i.x = x;
				i.y = y;
			}
		}


		/**
		 * Search for all nodes in a given rectangle
		 *
		 * NOTE: elements which lie on the right and below border will not be returned
		 *
		 * @param	Rectabgle r
		 * @return  Vector.<DisplayObject>
		 */
		public function search( r:Rectangle ):Vector.<DisplayObject>
		{
			if ( r.containsRect( new Rectangle( x, y, width, height ) ) )
			{
				return _getAll();
			}
			else if ( r.intersects( new Rectangle( x, y, width, height ) ) )
			{
				var objects:Vector.<DisplayObject> = new Vector.<DisplayObject>();

				if ( _subdivisions != null )
				{
					objects = objects.concat( _subdivisions[ 0 ].search( r ), _subdivisions[ 1 ].search( r ), _subdivisions[ 2 ].search( r ), _subdivisions[ 3 ].search( r ) );
				}
				else
				{
					for each ( var o:DisplayObject in _objects )
					{
						if ( o.width == 0 && o.height == 0 )
						{
							if ( r.containsPoint( new Point( o.x, o.y ) ) )
							{
								objects.push( o );
							}
						}
						else
						{
							if ( r.intersects( new Rectangle( o.x, o.y, o.width, o.height ) ) )
							{
								objects.push( o );
							}
						}
					}
				}

				return objects;
			}

			return new Vector.<DisplayObject>();
		}


		/**
		 * Draw the tree onto something, more used for testing.
		 *
		 * @param	Graphics g
		 */
		public function draw( g:Graphics ):void
		{
			if ( _subdivisions != null )
			{
				_subdivisions[ 0 ].draw( g );
				_subdivisions[ 1 ].draw( g );
				_subdivisions[ 2 ].draw( g );
				_subdivisions[ 3 ].draw( g );
			}

			g.lineStyle( 1, 0x0078a0, 0.2 );
			g.drawRect( x, y, width, height );
		}


		/**
		 * Find the section to which the DisplayObject belongs
		 *
		 * @param	DisplayObject i
		 * @return  QuadTree
		 */
		private function _find( i:DisplayObject ):QuadTree
		{
			if ( _objects != null && _objects.indexOf( i ) >= 0 )
			{
				return this;
			}
			else if ( _subdivisions != null )
			{
				var s:QuadTree = null;

				s = _subdivisions[ 0 ]._find( i );

				if ( s != null )
				{
					return s;
				}

				s = _subdivisions[ 1 ]._find( i );

				if ( s != null )
				{
					return s;
				}

				s = _subdivisions[ 2 ]._find( i );

				if ( s != null )
				{
					return s;
				}

				s = _subdivisions[ 3 ]._find( i );

				if ( s != null )
				{
					return s;
				}
			}

			return null;
		}


		/**
		 * Get all DisplayObject objects which fall into this region (and its subregions)
		 *
		 * @return	Vector.<DisplayObject>
		 */
		private function _getAll():Vector.<DisplayObject>
		{
			var objects:Vector.<DisplayObject> = new Vector.<DisplayObject>();

			if ( _subdivisions != null )
			{
				objects = objects.concat( _subdivisions[ 0 ]._getAll(), _subdivisions[ 1 ]._getAll(), _subdivisions[ 2 ]._getAll(), _subdivisions[ 3 ]._getAll() );
			}
			else
			{
				objects = objects.concat( _objects );
			}

			return objects;
		}


		/**
		 * Fix the tree by removing empty regions
		 */
		private function _fix():void
		{
			if ( _parent != null )
			{
				if ( _parent.size <= 1 )
				{
					_parent._fix();
					return;
				}
			}

			if ( size <= 1 )
			{
				var o:Vector.<DisplayObject> = new Vector.<DisplayObject>();
				o = o.concat( _getAll() );

				if ( _objects != null )
				{
					_objects.length = 0;
				}

				_objects = o;
				_subdivisions = null;
			}
		}


		/**
		 * Get a region based on x, y coordinate
		 *
		 * @param	int x
		 * @param	int y
		 * @return	QuadTree
		 */
		private function _getSub( x:int, y:int ):QuadTree
		{
			if ( _subdivisions == null )
			{
				return null;
			}

			var i:int = -1;

			if ( x <= this.x + width / 2 )
			{
				i = 0;
			}
			else
			{
				i = 2;
			}

			if ( y <= this.y + height / 2 )
			{
				i += 0;
			}
			else
			{
				i += 1;
			}

			return _subdivisions[ i ];
		}


		/**
		 * Get a leaf region based on x, y coordinate
		 *
		 * @param	int x
		 * @param	int y
		 * @return	QuadTree
		 */
		private function _getLeaf( x:int, y:int ):QuadTree
		{
			if ( _subdivisions == null )
			{
				return this;
			}
			else
			{
				return _getSub( x, y )._getLeaf( x, y );
			}
		}


		/**
		 * Subdevide this region into four new regions
		 */
		private function _subdivide():void
		{
			_subdivisions = new Vector.<QuadTree>();
			_subdivisions.push( new QuadTree( x, y, width / 2, height / 2, this ), new QuadTree( x, y + height / 2, width / 2, height / 2, this ), new QuadTree( x + width / 2, y, width / 2, height / 2, this ), new QuadTree( x + width / 2, y + height / 2, width / 2, height / 2, this ) );

			for ( var i:int = 0; i < _objects.length; i++ )
			{
				var j:DisplayObject = _objects[ i ];
				_getSub( j.x, j.y ).insert( j );
			}

			_objects = null;
		}
	}

}
